-- CollisionSystem.lua
-- Erweiterte Kollisionserkennung und Power-up Management

local CollisionSystem = {}

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local GameConfig = require(script.Parent.Parent.GameCore.GameConfig)
local TrackGenerator = require(script.Parent.TrackGenerator)

-- Power-up Zustände
CollisionSystem.PowerupStates = {
    NONE = "None",
    MAGNET = "Magnet", 
    INVINCIBLE = "Invincible",
    MULTIPLIER = "Multiplier"
}

-- Private Variablen
local activePowerups = {}
local collisionEffects = {}
local magnetRange = GameConfig.MAGNET_RANGE
local invincibilityTime = GameConfig.INVINCIBILITY_TIME

-- Events
local collisionDetected = Instance.new("BindableEvent")
local powerupActivated = Instance.new("BindableEvent")
local powerupExpired = Instance.new("BindableEvent")
local effectTriggered = Instance.new("BindableEvent")

-- Öffentliche Events
CollisionSystem.CollisionDetected = collisionDetected.Event
CollisionSystem.PowerupActivated = powerupActivated.Event
CollisionSystem.PowerupExpired = powerupExpired.Event
CollisionSystem.EffectTriggered = effectTriggered.Event

-- Kollisions-Datenstruktur
local CollisionData = {}
CollisionData.__index = CollisionData

function CollisionData.new(objectType, objectId, segmentId, playerState, powerupActive)
    local collision = {
        objectType = objectType,
        objectId = objectId,
        segmentId = segmentId,
        playerState = playerState,
        powerupActive = powerupActive,
        timestamp = tick(),
        handled = false
    }
    setmetatable(collision, CollisionData)
    return collision
end

-- Initialisierung
function CollisionSystem.initialize()
    activePowerups = {}
    collisionEffects = {}
    
    print("CollisionSystem initialisiert!")
end

-- Hauptkollisionsprüfung
function CollisionSystem.checkCollision(playerPosition, playerLane, playerState, trackObjects)
    local collisions = {}
    local collisionRange = 3
    
    for _, trackObj in pairs(trackObjects) do
        local objectData = trackObj.data
        
        -- Prüfe grundlegende Kollisionsbedingungen
        if shouldCheckCollision(objectData, playerPosition, playerLane, collisionRange) then
            local collision = CollisionData.new(
                objectData.type,
                objectData.id,
                trackObj.segmentId,
                playerState,
                getActivePowerupType()
            )
            
            table.insert(collisions, collision)
        end
    end
    
    -- Verarbeite alle Kollisionen
    for _, collision in pairs(collisions) do
        processCollision(collision)
    end
    
    return collisions
end

-- Prüfe ob Kollision überprüft werden soll
function shouldCheckCollision(objectData, playerPosition, playerLane, range)
    -- Distanz-Check
    local distance = math.abs(objectData.position - playerPosition)
    if distance > range then return false end
    
    -- Lane-Check
    if objectData.lane ~= playerLane then return false end
    
    -- Bereits gesammelt?
    if objectData.collected then return false end
    
    -- Magnet-Effekt für Münzen
    if objectData.type == TrackGenerator.ObjectTypes.COIN and isActivePowerup(CollisionSystem.PowerupStates.MAGNET) then
        local magnetDistance = math.abs(objectData.position - playerPosition)
        return magnetDistance <= magnetRange
    end
    
    return true
end

-- Kollision verarbeiten
function processCollision(collision)
    if collision.handled then return end
    
    collision.handled = true
    collisionDetected:Fire(collision)
    
    if collision.objectType == TrackGenerator.ObjectTypes.COIN then
        processCoinCollision(collision)
        
    elseif collision.objectType:find("POWERUP") then
        processPowerupCollision(collision)
        
    elseif collision.objectType:find("OBSTACLE") then
        processObstacleCollision(collision)
    end
end

-- Münz-Kollision
function processCoinCollision(collision)
    local scoreValue = GameConfig.COIN_VALUE
    
    -- Multiplikator anwenden
    if isActivePowerup(CollisionSystem.PowerupStates.MULTIPLIER) then
        scoreValue = scoreValue * 2
    end
    
    -- Effekt erstellen
    createCollectionEffect(collision, "coin", scoreValue)
    
    print("Münze gesammelt! Wert:", scoreValue)
end

-- Power-up Kollision
function processPowerupCollision(collision)
    local powerupType = collision.objectType
    local duration = GameConfig.POWERUP_DURATION
    
    -- Aktiviere Power-up
    activatePowerup(powerupType, duration)
    
    -- Effekt erstellen
    createCollectionEffect(collision, "powerup", powerupType)
    
    print("Power-up aktiviert:", powerupType, "für", duration, "Sekunden")
end

-- Hindernis-Kollision
function processObstacleCollision(collision)
    local playerState = collision.playerState
    local obstacleType = collision.objectType
    
    -- Unverwundbarkeit prüfen
    if isActivePowerup(CollisionSystem.PowerupStates.INVINCIBLE) then
        createCollisionEffect(collision, "invincible_hit")
        print("Hindernis ignoriert durch Unverwundbarkeit!")
        return
    end
    
    -- Normale Kollisionsprüfung
    local hitObstacle = false
    
    if obstacleType == TrackGenerator.ObjectTypes.OBSTACLE_LOW then
        -- Niedrige Hindernisse können durch Rutschen vermieden werden
        if playerState ~= "SLIDING" then
            hitObstacle = true
        end
    elseif obstacleType == TrackGenerator.ObjectTypes.OBSTACLE_HIGH then
        -- Hohe Hindernisse können durch Springen vermieden werden
        if playerState ~= "JUMPING" then
            hitObstacle = true
        end
    end
    
    if hitObstacle then
        createCollisionEffect(collision, "obstacle_hit")
        effectTriggered:Fire("game_over", collision)
        print("Hindernis getroffen! Game Over!")
    else
        createCollisionEffect(collision, "obstacle_avoided")
        print("Hindernis erfolgreich vermieden!")
    end
end

-- Power-up aktivieren
function activatePowerup(powerupType, duration)
    -- Deaktiviere aktuelles Power-up falls vorhanden
    if getActivePowerupType() ~= CollisionSystem.PowerupStates.NONE then
        deactivateCurrentPowerup()
    end
    
    local powerup = {
        type = powerupType,
        startTime = tick(),
        duration = duration,
        active = true
    }
    
    activePowerups[powerupType] = powerup
    powerupActivated:Fire(powerupType, duration)
    
    -- Auto-Deaktivierung nach Ablauf
    spawn(function()
        wait(duration)
        if activePowerups[powerupType] and activePowerups[powerupType].active then
            deactivatePowerup(powerupType)
        end
    end)
end

-- Power-up deaktivieren
function deactivatePowerup(powerupType)
    if activePowerups[powerupType] then
        activePowerups[powerupType].active = false
        activePowerups[powerupType] = nil
        powerupExpired:Fire(powerupType)
        print("Power-up abgelaufen:", powerupType)
    end
end

-- Aktuelles Power-up deaktivieren
function deactivateCurrentPowerup()
    for powerupType, powerup in pairs(activePowerups) do
        if powerup.active then
            deactivatePowerup(powerupType)
            break
        end
    end
end

-- Prüfe ob Power-up aktiv ist
function isActivePowerup(powerupType)
    local powerup = activePowerups[powerupType]
    return powerup and powerup.active and (tick() - powerup.startTime) < powerup.duration
end

-- Aktueller Power-up Typ
function getActivePowerupType()
    for powerupType, powerup in pairs(activePowerups) do
        if powerup.active and (tick() - powerup.startTime) < powerup.duration then
            return powerupType
        end
    end
    return CollisionSystem.PowerupStates.NONE
end

-- Sammel-Effekt erstellen
function createCollectionEffect(collision, effectType, value)
    local effectData = {
        type = effectType,
        collision = collision,
        value = value,
        timestamp = tick()
    }
    
    table.insert(collisionEffects, effectData)
    effectTriggered:Fire(effectType, effectData)
end

-- Kollisions-Effekt erstellen
function createCollisionEffect(collision, effectType)
    local effectData = {
        type = effectType,
        collision = collision,
        timestamp = tick()
    }
    
    table.insert(collisionEffects, effectData)
    effectTriggered:Fire(effectType, effectData)
end

-- Magnet-Effekt für Münzen
function CollisionSystem.getMagnetizedCoins(playerPosition, trackObjects)
    if not isActivePowerup(CollisionSystem.PowerupStates.MAGNET) then
        return {}
    end
    
    local magnetizedCoins = {}
    
    for _, trackObj in pairs(trackObjects) do
        local objectData = trackObj.data
        
        if objectData.type == TrackGenerator.ObjectTypes.COIN and not objectData.collected then
            local distance = math.abs(objectData.position - playerPosition)
            
            if distance <= magnetRange then
                table.insert(magnetizedCoins, trackObj)
            end
        end
    end
    
    return magnetizedCoins
end

-- Power-up Restzeit
function CollisionSystem.getPowerupTimeRemaining(powerupType)
    local powerup = activePowerups[powerupType]
    if not powerup or not powerup.active then return 0 end
    
    local elapsed = tick() - powerup.startTime
    local remaining = powerup.duration - elapsed
    return math.max(0, remaining)
end

-- Alle aktiven Power-ups
function CollisionSystem.getActivePowerups()
    local active = {}
    
    for powerupType, powerup in pairs(activePowerups) do
        if powerup.active and (tick() - powerup.startTime) < powerup.duration then
            active[powerupType] = {
                type = powerupType,
                remaining = powerup.duration - (tick() - powerup.startTime)
            }
        end
    end
    
    return active
end

-- System zurücksetzen
function CollisionSystem.reset()
    -- Alle Power-ups deaktivieren
    for powerupType, _ in pairs(activePowerups) do
        deactivatePowerup(powerupType)
    end
    
    activePowerups = {}
    collisionEffects = {}
    
    print("CollisionSystem zurückgesetzt")
end

-- Debug-Informationen
function CollisionSystem.getDebugInfo()
    return {
        activePowerups = getActivePowerupType(),
        powerupCount = #activePowerups,
        effectCount = #collisionEffects,
        magnetRange = magnetRange
    }
end

-- Öffentliche Getter
function CollisionSystem.isInvincible()
    return isActivePowerup(CollisionSystem.PowerupStates.INVINCIBLE)
end

function CollisionSystem.hasMagnet()
    return isActivePowerup(CollisionSystem.PowerupStates.MAGNET)
end

function CollisionSystem.hasMultiplier()
    return isActivePowerup(CollisionSystem.PowerupStates.MULTIPLIER)
end

function CollisionSystem.getCurrentPowerup()
    return getActivePowerupType()
end

return CollisionSystem