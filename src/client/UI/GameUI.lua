-- GameUI.lua
-- Benutzeroberfläche für Subway Surfer Klon

local GameUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local GameManager = require(game.ReplicatedStorage.Shared.GameCore.GameManager)
local PlayerController = require(game.ReplicatedStorage.Shared.Systems.PlayerController)

-- UI Elemente
local screenGui = nil
local gameHUD = nil
local mainMenu = nil
local gameOverScreen = nil
local pauseMenu = nil

-- HUD Elemente
local scoreLabel = nil
local coinLabel = nil
local speedLabel = nil
local powerupFrame = nil
local powerupIcon = nil
local powerupTimer = nil

-- Private Variablen
local localPlayer = Players.LocalPlayer
local uiInitialized = false
local currentPowerup = nil
local powerupEndTime = 0

-- UI-Konfiguration
local UI_CONFIG = {
    HUD_SIZE = UDim2.new(1, 0, 1, 0),
    BUTTON_SIZE = UDim2.new(0, 200, 0, 50),
    LABEL_SIZE = UDim2.new(0, 200, 0, 40),
    COLORS = {
        BACKGROUND = Color3.new(0, 0, 0),
        TEXT = Color3.new(1, 1, 1),
        BUTTON = Color3.new(0.2, 0.6, 1),
        BUTTON_HOVER = Color3.new(0.3, 0.7, 1),
        COIN = Color3.new(1, 0.8, 0),
        SCORE = Color3.new(0, 1, 0.5),
        SPEED = Color3.new(1, 0.5, 0)
    }
}

-- Initialisierung
function GameUI.initialize()
    if uiInitialized then return end
    
    print("GameUI wird initialisiert...")
    
    -- Haupt-ScreenGui erstellen
    createScreenGui()
    
    -- UI-Komponenten erstellen
    createMainMenu()
    createGameHUD()
    createGameOverScreen()
    createPauseMenu()
    
    -- Event-Verbindungen
    connectEvents()
    
    -- Zeige Hauptmenü
    showMainMenu()
    
    uiInitialized = true
    print("GameUI initialisiert!")
end

-- ScreenGui erstellen
function createScreenGui()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SubwaySurferUI"
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
end

-- Hauptmenü erstellen
function createMainMenu()
    mainMenu = Instance.new("Frame")
    mainMenu.Name = "MainMenu"
    mainMenu.Size = UI_CONFIG.HUD_SIZE
    mainMenu.Position = UDim2.new(0, 0, 0, 0)
    mainMenu.BackgroundColor3 = UI_CONFIG.COLORS.BACKGROUND
    mainMenu.BackgroundTransparency = 0.3
    mainMenu.Parent = screenGui
    
    -- Titel
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 400, 0, 80)
    title.Position = UDim2.new(0.5, -200, 0.2, 0)
    title.BackgroundTransparency = 1
    title.Text = "🏃‍♂️ SUBWAY SURFER"
    title.TextColor3 = UI_CONFIG.COLORS.TEXT
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainMenu
    
    -- Untertitel
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(0, 300, 0, 40)
    subtitle.Position = UDim2.new(0.5, -150, 0.35, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Roblox Klon"
    subtitle.TextColor3 = UI_CONFIG.COLORS.TEXT
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.SourceSans
    subtitle.Parent = mainMenu
    
    -- Spiel starten Button
    local playButton = createButton("PlayButton", "SPIELEN", UDim2.new(0.5, -100, 0.5, 0), mainMenu)
    playButton.MouseButton1Click:Connect(function()
        startGame()
    end)
    
    -- Anleitung
    local instructions = Instance.new("TextLabel")
    instructions.Name = "Instructions"
    instructions.Size = UDim2.new(0, 400, 0, 120)
    instructions.Position = UDim2.new(0.5, -200, 0.65, 0)
    instructions.BackgroundTransparency = 1
    instructions.Text = "STEUERUNG:\nA/D oder ←/→ - Bewegen\nW/↑/SPACE - Springen\nS/↓/CTRL - Rutschen\nP/ESC - Pause"
    instructions.TextColor3 = UI_CONFIG.COLORS.TEXT
    instructions.TextScaled = true
    instructions.Font = Enum.Font.SourceSans
    instructions.Parent = mainMenu
end

-- Game HUD erstellen
function createGameHUD()
    gameHUD = Instance.new("Frame")
    gameHUD.Name = "GameHUD"
    gameHUD.Size = UI_CONFIG.HUD_SIZE
    gameHUD.Position = UDim2.new(0, 0, 0, 0)
    gameHUD.BackgroundTransparency = 1
    gameHUD.Visible = false
    gameHUD.Parent = screenGui
    
    -- Score
    scoreLabel = Instance.new("TextLabel")
    scoreLabel.Name = "ScoreLabel"
    scoreLabel.Size = UDim2.new(0, 200, 0, 50)
    scoreLabel.Position = UDim2.new(0, 20, 0, 20)
    scoreLabel.BackgroundTransparency = 1
    scoreLabel.Text = "SCORE: 0"
    scoreLabel.TextColor3 = UI_CONFIG.COLORS.SCORE
    scoreLabel.TextScaled = true
    scoreLabel.Font = Enum.Font.SourceSansBold
    scoreLabel.TextXAlignment = Enum.TextXAlignment.Left
    scoreLabel.Parent = gameHUD
    
    -- Münzen
    coinLabel = Instance.new("TextLabel")
    coinLabel.Name = "CoinLabel"
    coinLabel.Size = UDim2.new(0, 150, 0, 40)
    coinLabel.Position = UDim2.new(0, 20, 0, 80)
    coinLabel.BackgroundTransparency = 1
    coinLabel.Text = "🪙 0"
    coinLabel.TextColor3 = UI_CONFIG.COLORS.COIN
    coinLabel.TextScaled = true
    coinLabel.Font = Enum.Font.SourceSans
    coinLabel.TextXAlignment = Enum.TextXAlignment.Left
    coinLabel.Parent = gameHUD
    
    -- Geschwindigkeit
    speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0, 150, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 130)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "SPEED: 50"
    speedLabel.TextColor3 = UI_CONFIG.COLORS.SPEED
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = gameHUD
    
    -- Power-up Anzeige
    powerupFrame = Instance.new("Frame")
    powerupFrame.Name = "PowerupFrame"
    powerupFrame.Size = UDim2.new(0, 100, 0, 100)
    powerupFrame.Position = UDim2.new(1, -120, 0, 20)
    powerupFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    powerupFrame.BackgroundTransparency = 0.5
    powerupFrame.Visible = false
    powerupFrame.Parent = gameHUD
    
    powerupIcon = Instance.new("TextLabel")
    powerupIcon.Name = "PowerupIcon"
    powerupIcon.Size = UDim2.new(1, 0, 0.7, 0)
    powerupIcon.Position = UDim2.new(0, 0, 0, 0)
    powerupIcon.BackgroundTransparency = 1
    powerupIcon.Text = "⚡"
    powerupIcon.TextColor3 = UI_CONFIG.COLORS.TEXT
    powerupIcon.TextScaled = true
    powerupIcon.Font = Enum.Font.SourceSansBold
    powerupIcon.Parent = powerupFrame
    
    powerupTimer = Instance.new("TextLabel")
    powerupTimer.Name = "PowerupTimer"
    powerupTimer.Size = UDim2.new(1, 0, 0.3, 0)
    powerupTimer.Position = UDim2.new(0, 0, 0.7, 0)
    powerupTimer.BackgroundTransparency = 1
    powerupTimer.Text = "10s"
    powerupTimer.TextColor3 = UI_CONFIG.COLORS.TEXT
    powerupTimer.TextScaled = true
    powerupTimer.Font = Enum.Font.SourceSans
    powerupTimer.Parent = powerupFrame
    
    -- Pause Button
    local pauseButton = createButton("PauseButton", "⏸", UDim2.new(1, -60, 0, 20), gameHUD)
    pauseButton.Size = UDim2.new(0, 40, 0, 40)
    pauseButton.MouseButton1Click:Connect(function()
        pauseGame()
    end)
end

-- Game Over Screen erstellen
function createGameOverScreen()
    gameOverScreen = Instance.new("Frame")
    gameOverScreen.Name = "GameOverScreen"
    gameOverScreen.Size = UI_CONFIG.HUD_SIZE
    gameOverScreen.Position = UDim2.new(0, 0, 0, 0)
    gameOverScreen.BackgroundColor3 = UI_CONFIG.COLORS.BACKGROUND
    gameOverScreen.BackgroundTransparency = 0.2
    gameOverScreen.Visible = false
    gameOverScreen.Parent = screenGui
    
    -- Game Over Titel
    local gameOverTitle = Instance.new("TextLabel")
    gameOverTitle.Name = "GameOverTitle"
    gameOverTitle.Size = UDim2.new(0, 300, 0, 80)
    gameOverTitle.Position = UDim2.new(0.5, -150, 0.25, 0)
    gameOverTitle.BackgroundTransparency = 1
    gameOverTitle.Text = "GAME OVER"
    gameOverTitle.TextColor3 = Color3.new(1, 0, 0)
    gameOverTitle.TextScaled = true
    gameOverTitle.Font = Enum.Font.SourceSansBold
    gameOverTitle.Parent = gameOverScreen
    
    -- Final Score
    local finalScoreLabel = Instance.new("TextLabel")
    finalScoreLabel.Name = "FinalScoreLabel"
    finalScoreLabel.Size = UDim2.new(0, 300, 0, 60)
    finalScoreLabel.Position = UDim2.new(0.5, -150, 0.4, 0)
    finalScoreLabel.BackgroundTransparency = 1
    finalScoreLabel.Text = "Final Score: 0"
    finalScoreLabel.TextColor3 = UI_CONFIG.COLORS.SCORE
    finalScoreLabel.TextScaled = true
    finalScoreLabel.Font = Enum.Font.SourceSans
    finalScoreLabel.Parent = gameOverScreen
    
    -- Restart Button
    local restartButton = createButton("RestartButton", "NOCHMAL", UDim2.new(0.5, -100, 0.55, 0), gameOverScreen)
    restartButton.MouseButton1Click:Connect(function()
        restartGame()
    end)
    
    -- Menu Button
    local menuButton = createButton("MenuButton", "HAUPTMENÜ", UDim2.new(0.5, -100, 0.65, 0), gameOverScreen)
    menuButton.MouseButton1Click:Connect(function()
        returnToMenu()
    end)
end

-- Pause Menu erstellen
function createPauseMenu()
    pauseMenu = Instance.new("Frame")
    pauseMenu.Name = "PauseMenu"
    pauseMenu.Size = UI_CONFIG.HUD_SIZE
    pauseMenu.Position = UDim2.new(0, 0, 0, 0)
    pauseMenu.BackgroundColor3 = UI_CONFIG.COLORS.BACKGROUND
    pauseMenu.BackgroundTransparency = 0.3
    pauseMenu.Visible = false
    pauseMenu.Parent = screenGui
    
    -- Pause Titel
    local pauseTitle = Instance.new("TextLabel")
    pauseTitle.Name = "PauseTitle"
    pauseTitle.Size = UDim2.new(0, 200, 0, 60)
    pauseTitle.Position = UDim2.new(0.5, -100, 0.3, 0)
    pauseTitle.BackgroundTransparency = 1
    pauseTitle.Text = "PAUSE"
    pauseTitle.TextColor3 = UI_CONFIG.COLORS.TEXT
    pauseTitle.TextScaled = true
    pauseTitle.Font = Enum.Font.SourceSansBold
    pauseTitle.Parent = pauseMenu
    
    -- Resume Button
    local resumeButton = createButton("ResumeButton", "WEITER", UDim2.new(0.5, -100, 0.45, 0), pauseMenu)
    resumeButton.MouseButton1Click:Connect(function()
        resumeGame()
    end)
    
    -- Menu Button
    local menuButton = createButton("MenuButton", "HAUPTMENÜ", UDim2.new(0.5, -100, 0.55, 0), pauseMenu)
    menuButton.MouseButton1Click:Connect(function()
        returnToMenu()
    end)
end

-- Button-Hilfsfunktion
function createButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UI_CONFIG.BUTTON_SIZE
    button.Position = position
    button.BackgroundColor3 = UI_CONFIG.COLORS.BUTTON
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = UI_CONFIG.COLORS.TEXT
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent
    
    -- Hover-Effekt
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = UI_CONFIG.COLORS.BUTTON_HOVER
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = UI_CONFIG.COLORS.BUTTON
        })
        tween:Play()
    end)
    
    return button
end

-- Event-Verbindungen
function connectEvents()
    -- Game Manager Events
    GameManager.GameStateChanged:Connect(onGameStateChanged)
    GameManager.ScoreUpdated:Connect(onScoreUpdated)
    GameManager.CoinCollected:Connect(onCoinCollected)
    
    -- Keyboard Shortcuts
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.P or input.KeyCode == Enum.KeyCode.Escape then
            togglePause()
        end
    end)
end

-- Event Handlers
function onGameStateChanged(newState)
    if newState == GameManager.GameStates.MENU then
        showMainMenu()
    elseif newState == GameManager.GameStates.PLAYING then
        showGameHUD()
    elseif newState == GameManager.GameStates.PAUSED then
        showPauseMenu()
    elseif newState == GameManager.GameStates.GAME_OVER then
        showGameOverScreen()
    end
end

function onScoreUpdated(score, distance)
    if scoreLabel then
        scoreLabel.Text = "SCORE: " .. math.floor(score)
    end
    
    if speedLabel then
        speedLabel.Text = "SPEED: " .. math.floor(GameManager.getCurrentSpeed())
    end
end

function onCoinCollected(coins)
    if coinLabel then
        coinLabel.Text = "🪙 " .. coins
        
        -- Münz-Sammel Animation
        local originalSize = coinLabel.Size
        local tween = TweenService:Create(coinLabel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = originalSize * 1.2
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            local backTween = TweenService:Create(coinLabel, TweenInfo.new(0.2), {
                Size = originalSize
            })
            backTween:Play()
        end)
    end
end

-- UI-Zustandsverwaltung
function showMainMenu()
    hideAllScreens()
    mainMenu.Visible = true
end

function showGameHUD()
    hideAllScreens()
    gameHUD.Visible = true
end

function showGameOverScreen()
    hideAllScreens()
    gameOverScreen.Visible = true
    
    -- Update Final Score
    local finalScoreLabel = gameOverScreen:FindFirstChild("FinalScoreLabel")
    if finalScoreLabel then
        finalScoreLabel.Text = "Final Score: " .. math.floor(GameManager.getScore())
    end
end

function showPauseMenu()
    pauseMenu.Visible = true
end

function hideAllScreens()
    mainMenu.Visible = false
    gameHUD.Visible = false
    gameOverScreen.Visible = false
    pauseMenu.Visible = false
end

-- Game Actions
function startGame()
    GameManager.startGame()
end

function pauseGame()
    GameManager.pauseGame()
end

function resumeGame()
    GameManager.resumeGame()
end

function restartGame()
    GameManager.returnToMenu()
    wait(0.1)
    GameManager.startGame()
end

function returnToMenu()
    GameManager.returnToMenu()
end

function togglePause()
    local currentState = GameManager.getCurrentState()
    if currentState == GameManager.GameStates.PLAYING then
        pauseGame()
    elseif currentState == GameManager.GameStates.PAUSED then
        resumeGame()
    end
end

-- Power-up UI Update
function GameUI.updatePowerup(powerupType, timeRemaining)
    if not powerupFrame then return end
    
    if powerupType and timeRemaining > 0 then
        powerupFrame.Visible = true
        
        -- Icon aktualisieren
        local icons = {
            ["POWERUP_MAGNET"] = "🧲",
            ["POWERUP_INVINCIBLE"] = "🛡️",
            ["POWERUP_MULTIPLIER"] = "✖️"
        }
        
        powerupIcon.Text = icons[powerupType] or "⚡"
        powerupTimer.Text = math.ceil(timeRemaining) .. "s"
        
        currentPowerup = powerupType
        powerupEndTime = tick() + timeRemaining
    else
        powerupFrame.Visible = false
        currentPowerup = nil
    end
end

-- Update Loop für Power-up Timer
spawn(function()
    while true do
        wait(0.1)
        
        if currentPowerup and powerupEndTime > tick() then
            local remaining = powerupEndTime - tick()
            if powerupTimer and remaining > 0 then
                powerupTimer.Text = math.ceil(remaining) .. "s"
            else
                GameUI.updatePowerup(nil, 0)
            end
        end
    end
end)

return GameUI