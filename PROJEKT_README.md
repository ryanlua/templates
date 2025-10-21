# Roblox Projekt - Entwicklungsumgebung

Dieses Projekt ist vollständig für die Roblox-Entwicklung im Dev Container konfiguriert.

## ✅ Installierte Tools

- **Rojo 7.6.0** - Für Synchronisation mit Roblox Studio
- **Rokit** - Toolchain Manager
- **StyLua** - Code-Formatierung
- **Selene** - Linting
- **Luau Language Server** - IntelliSense

## 📁 Projektstruktur

```
├── src/
│   ├── server/          # Server-seitige Skripte
│   │   └── init.server.lua
│   ├── client/          # Client-seitige Skripte
│   │   └── init.client.lua
│   └── shared/          # Gemeinsame Module
│       └── SharedUtils.lua
├── default.project.json # Rojo-Konfiguration
├── rokit.toml          # Toolchain-Konfiguration
├── wally.toml          # Paket-Manager-Konfiguration
├── stylua.toml         # Code-Formatierung
└── selene.toml         # Linter-Konfiguration
```

## 🚀 Verwendung

### Rojo-Server läuft bereits!

Der Rojo-Server ist auf Port **34872** gestartet und läuft im Hintergrund.

### Mit Roblox Studio synchronisieren

1. Installieren Sie das [Rojo-Plugin](https://create.roblox.com/store/asset/13916111004) in Roblox Studio
2. In GitHub Codespaces:
   - Gehen Sie zum **PORTS**-Tab
   - Finden Sie Port `34872` (Rojo)
   - Kopieren Sie die forwarded Address (z.B. `your-project-34872.app.github.dev`)
3. In Roblox Studio:
   - Öffnen Sie das Rojo-Plugin
   - Setzen Sie Port auf **80** (nicht 34872!)
   - Entfernen Sie `https://` am Anfang und `/` am Ende
   - Beispiel: `your-project-34872.app.github.dev`
   - Klicken Sie auf **Connect**

### Place-Datei erstellen

```bash
rojo build -o MeinSpiel.rbxl
```

### Rojo-Server manuell starten

Falls der Server gestoppt wurde:

```bash
rojo serve
```

### Code formatieren

```bash
stylua src/
```

### Code-Qualität prüfen

```bash
selene src/
```

## 🛠️ Nächste Schritte

1. **Wally-Pakete hinzufügen**: Bearbeiten Sie `wally.toml` und führen Sie `wally install` aus
2. **Zusätzliche Skripte**: Erstellen Sie neue `.lua`-Dateien in `src/server/`, `src/client/` oder `src/shared/`
3. **Rojo-Konfiguration anpassen**: Bearbeiten Sie `default.project.json` nach Bedarf

## 📚 Ressourcen

- [Rojo Dokumentation](https://rojo.space/docs/)
- [Wally Dokumentation](https://wally.run/)
- [Luau Dokumentation](https://luau-lang.org/)
- [Roblox Creator Docs](https://create.roblox.com/docs)
