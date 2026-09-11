# Dalamud plugins

Custom plugin repository for my FFXIV Dalamud plugins.

Add this URL in `/xlsettings` > Experimental > Custom Plugin Repositories:

```
https://raw.githubusercontent.com/BSoD38/dalamud-plugins/main/pluginmaster.json
```

| Plugin | Source |
| --- | --- |
| Inverse Kinematics | https://github.com/BSoD38/ffxiv-real-time-ik |

## Releasing

Build the plugin in Release, then point the script at DalamudPackager's output folder:

```powershell
.\publish.ps1 D:\dev\ffxiv-real-time-ik\FootIk\bin\Release\FootIk -Icon D:\dev\ffxiv-real-time-ik\FootIk\images\icon.png
```

It copies `<Name>.json`, `latest.zip` and the optional icon into `plugins/<Name>/`, regenerates `pluginmaster.json`, commits and pushes.
