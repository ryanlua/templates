# 🏃‍♂️ Subway Surfer Klon für Roblox

Ein vollständiger Subway Surfer-Klon entwickelt in Roblox mit modernen Entwicklungspraktiken.

## 🎮 Spielmerkmale

### Core Gameplay
- **Endless Runner Mechanik** - Unendliches Laufen mit steigender Geschwindigkeit
- **3-Spur System** - Links, Mitte, Rechts Bewegung
- **Sprung & Rutsch-Mechaniken** - Dynamische Bewegungen zum Hindernissen ausweichen
- **Münzen sammeln** - Sammle Münzen für Punkte
- **Power-ups** - Spezielle Items mit temporären Fähigkeiten
- **Kollisionssystem** - Realistische Kollisionserkennung mit Hindernissen

### Steuerung
- **Keyboard**: 
  - `A`/`Pfeil Links` - Nach links bewegen
  - `D`/`Pfeil Rechts` - Nach rechts bewegen  
  - `W`/`Pfeil Hoch`/`Space` - Springen
  - `S`/`Pfeil Runter`/`Ctrl` - Rutschen
  - `P`/`Escape` - Pause
- **Mobile/Touch**:
  - Swipe Links/Rechts - Seitliche Bewegung
  - Swipe Hoch - Springen
  - Swipe Runter - Rutschen
  - Tap - Springen

## 📁 Projektstruktur

```
src/
├── shared/                    # Geteilte Module (Client & Server)
│   ├── GameCore/
│   │   ├── GameConfig.lua     # Zentrale Spielkonfiguration
│   │   └── GameManager.lua    # Hauptspiel-Logik & Zustandsverwaltung
│   ├── Systems/
│   │   └── PlayerController.lua # Spieler-Bewegung & -Zustand
│   └── SharedUtils.lua        # Gemeinsame Hilfsfunktionen
├── client/                    # Client-seitige Skripte
│   ├── Controllers/
│   │   └── InputManager.lua   # Input-Verarbeitung (Keyboard & Touch)
│   ├── UI/                    # Benutzeroberflächen (zukünftig)
│   └── init.client.lua        # Client-Hauptskript
└── server/                    # Server-seitige Skripte
    ├── Services/              # Server-Services (zukünftig)
    └── init.server.lua        # Server-Hauptskript
```

## 🛠️ Entwicklung

### Voraussetzungen
- Roblox Studio
- Rojo Plugin für Roblox Studio
- VS Code mit Luau LSP Extension (empfohlen)

### Setup
1. **Repository klonen**
   ```bash
   git clone <repository-url>
   cd templates
   ```

2. **Dependencies installieren**
   ```bash
   rokit install --no-trust-check
   ```

3. **Rojo-Server starten**
   ```bash
   rojo serve
   ```

4. **In Roblox Studio verbinden**
   - Installiere das [Rojo Plugin](https://create.roblox.com/store/asset/13916111004)
   - Verbinde mit dem lokalen Rojo-Server (Standard: `localhost:34872`)

### Code-Qualität
- **Formatierung**: `stylua src/`
- **Linting**: `selene src/`
- **Building**: `rojo build -o SubwaySurferClone.rbxl`

## 🏗️ Architektur

### Game States
- **MENU** - Hauptmenü
- **PLAYING** - Aktives Gameplay  
- **PAUSED** - Spiel pausiert
- **GAME_OVER** - Spiel beendet

### Player States  
- **RUNNING** - Normal laufend
- **JUMPING** - Springend
- **SLIDING** - Rutschend
- **DEAD** - Gestorben

### Event-System
Das Spiel nutzt ein Event-basiertes System für die Kommunikation zwischen Modulen:
- `GameStateChanged` - Game State Änderungen
- `ScoreUpdated` - Score & Distanz Updates
- `CoinCollected` - Münzen gesammelt
- `LaneChanged` - Spur-Wechsel
- `StateChanged` - Player State Änderungen

## 📋 Roadmap

### ✅ Phase 1: Core Systems (Aktuell)
- [x] Grundlegende Projektstruktur
- [x] Game Manager & Config
- [x] Player Controller
- [x] Input System (Keyboard & Touch)
- [x] Basic Game Loop

### 🚧 Phase 2: Gameplay Features  
- [ ] Track Generation System
- [ ] Hindernisse & Kollision
- [ ] Münzen & Power-ups
- [ ] Partikel-Effekte

### 📋 Phase 3: UI & Polish
- [ ] Hauptmenü UI
- [ ] In-Game HUD
- [ ] Game Over Screen  
- [ ] Pause Menu
- [ ] Sound-System

### 🔧 Phase 4: Advanced Features
- [ ] Leaderboards
- [ ] Character Skins
- [ ] Achievements
- [ ] Daily Challenges

## 🤝 Beitragen

1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Committe deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## 📝 Code-Standards

- **Luau/Lua** für alle Skripte
- **Modulares Design** - Jede Funktionalität in separaten Modulen
- **Event-basierte Kommunikation** zwischen Modulen
- **Konsistente Namenskonventionen**
- **Kommentare** für komplexe Logik
- **Error Handling** für robuste Systeme

## 🐛 Debugging

### Häufige Probleme
1. **Rojo-Verbindung fehlgeschlagen**
   - Prüfe ob Rojo-Server läuft
   - Überprüfe Firewall-Einstellungen

2. **Module können nicht geladen werden**
   - Prüfe `default.project.json` Konfiguration
   - Überprüfe Dateipfade

3. **Input funktioniert nicht**
   - Prüfe ob Game State auf `PLAYING` gesetzt ist
   - Überprüfe Touch-Einstellungen bei Mobile

### Debug-Befehle
```lua
-- Im Command Bar von Roblox Studio
print("Game State:", GameManager.getCurrentState())
print("Player Lane:", PlayerController.getCurrentLane())  
print("Current Score:", GameManager.getScore())
```

## 📄 Lizenz

MIT License - siehe [LICENSE](LICENSE) Datei für Details.

## 🔗 Ressourcen

- [Roblox Developer Hub](https://create.roblox.com/docs)
- [Rojo Documentation](https://rojo.space/docs/)
- [Luau Language Guide](https://luau-lang.org/)
- [Rokit Toolchain Manager](https://github.com/rojo-rbx/rokit)

---

**Viel Spaß beim Entwickeln! 🚀**