-- Gemeinsame Utilities die sowohl vom Server als auch Client verwendet werden können
local SharedUtils = {}

-- Begrüßt einen Spieler (Server-seitig)
function SharedUtils.welcomePlayer(player)
    if player and player.Name then
        print("Willkommen", player.Name, "zu unserem Spiel!")
    end
end

-- Setup für Spieler (Client-seitig)  
function SharedUtils.setupPlayer(player)
    if player and player.Name then
        print("Setup für Spieler:", player.Name)
        -- Hier können Client-spezifische Setups hinzugefügt werden
    end
end

-- Utility-Funktion für Berechnungen
function SharedUtils.calculateDistance(pos1, pos2)
    if pos1 and pos2 then
        return (pos1 - pos2).Magnitude
    end
    return 0
end

-- Utility-Funktion für Formatierung
function SharedUtils.formatTime(seconds)
    if not seconds then return "00:00" end
    
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

return SharedUtils
