-- Client-seitiges Hauptskript - Subway Surfer Klon
print("Subway Surfer Klon Client gestartet!")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importiere Game-Module
local SharedUtils = require(game.ReplicatedStorage.Shared.SharedUtils)
local GameManager = require(game.ReplicatedStorage.Shared.GameCore.GameManager)
local PlayerController = require(game.ReplicatedStorage.Shared.Systems.PlayerController)
local InputManager = require(script.Controllers.InputManager)
local TrackManager = require(script.Controllers.TrackManager)
local GameUI = require(script.UI.GameUI)

-- Lokale Variablen
local localPlayer = Players.LocalPlayer
local gameInitialized = false

-- Initialisierung
local function initializeGame()
    if gameInitialized then return end
    
    print("Initialisiere Subway Surfer Klon...")
    
    -- UI-System zuerst initialisieren
    GameUI.initialize()
    
    -- Input-System initialisieren
    InputManager.initialize()
    
    -- Track-System initialisieren
    TrackManager.initialize()
    
    -- Game Manager Events
    GameManager.GameStateChanged:Connect(function(newState)
        print("Game State geändert zu:", newState)
    end)
    
    GameManager.ScoreUpdated:Connect(function(score, distance)
        print("Score:", math.floor(score), "Distanz:", math.floor(distance))
    end)
    
    GameManager.CoinCollected:Connect(function(coins)
        print("Münzen gesammelt:", coins)
    end)
    
    -- Player Controller Events
    PlayerController.LaneChanged:Connect(function(lane)
        print("Neue Spur:", lane)
    end)
    
    PlayerController.StateChanged:Connect(function(state)
        print("Player State:", state)
    end)
    
    gameInitialized = true
    print("Subway Surfer Klon Client initialisiert!")
end

-- Game Loop
local function onHeartbeat(deltaTime)
    if gameInitialized and GameManager.getCurrentState() == GameManager.GameStates.PLAYING then
        -- Update Score
        GameManager.updateScore(deltaTime)
        
        -- Debug Info (weniger häufig)
        if math.random() < 0.005 then -- 0.5% Chance pro Frame
            print("Track Objects:", TrackManager.getActiveObjectCount(), "Player Pos:", math.floor(TrackManager.getCurrentPosition()))
        end
    end
end

-- Spieler-Events
localPlayer.CharacterAdded:Connect(function(_character)
    print("Charakter gespawnt für:", localPlayer.Name)
    SharedUtils.setupPlayer(localPlayer)
    
    -- Initialisiere Game nach Character-Spawn
    wait(1) -- Kurz warten bis alles geladen ist
    initializeGame()
end)

localPlayer.CharacterRemoving:Connect(function()
    print("Charakter wird entfernt")
end)

-- Game Loop starten
RunService.Heartbeat:Connect(onHeartbeat)

-- Test-Funktionen (für Development) - Deaktiviert für UI-Testing
--[[
local function testGame()
    wait(3) -- Etwas länger warten für Track-System
    if gameInitialized then
        print("Starte Test-Spiel...")
        GameManager.startGame()
        
        -- Teste Player Movement nach 5 Sekunden
        wait(5)
        print("Teste Bewegungen...")
        PlayerController.moveRight()
        wait(2)
        PlayerController.jump()
        wait(3)
        PlayerController.moveLeft()
        wait(2)
        PlayerController.slide()
        wait(3)
        PlayerController.moveRight()
        
        -- Debug-Info ausgeben
        wait(2)
        local debugInfo = {
            gameState = GameManager.getCurrentState(),
            playerLane = PlayerController.getCurrentLane(),
            playerState = PlayerController.getCurrentState(),
            score = GameManager.getScore(),
            coins = GameManager.getCoins(),
            trackObjects = TrackManager.getActiveObjectCount(),
            playerPosition = TrackManager.getCurrentPosition()
        }
        
        print("=== GAME DEBUG INFO ===")
        for key, value in pairs(debugInfo) do
            print(key .. ":", value)
        end
        print("======================")
    end
end

-- Starte Test (nur für Development)
spawn(testGame)
--]]

print("Client bereit! Benutze das Hauptmenü zum Spielen.")
