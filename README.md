# GAS-NPP-Example-Project

This repository provides a quick and streamlined way to try out the example project [GAS-NPP-Simulation](https://github.com/Sabri-Kai/GAS-NPP-Simulation) created by [Sabri-Kai](https://github.com/Sabri-Kai).
All plugins and example content included or referenced in this project belong to [Sabri-Kai](https://github.com/Sabri-Kai).

Setting up the plugins correctly can be challenging due to dependencies and engine-version constraints.
This repository includes an automated setup script designed to resolve those issues and get you running the example project faster.

## Requirements

- Windows
- PowerShell
- Git
- Unreal Engine 5.7

## Setup

Clone the repository using a Git-enabled terminal:

```bash
git clone https://github.com/primody/GAS-NPP-Example-Project.git
```

Navigate into the project folder:

```bash
cd GAS-NPP-Example-Project
```

### Running the Setup Script

The PowerShell setup script performs three main tasks:

1. Detect Unreal Engine 5.7 Installation
   - Searches for the default installation directory (typically `C:\Program Files\Epic Games\UE_5.7').
   - If found, required engine plugins are copied from `Engine\Plugins` into this project's `Plugins` directory. These plugins are unmodified engine plugins required by the provided dependencies.
   - If not found, the script stops and provides guidance on how to specify a custom engine path.
2. Clone Modified `AbilitySystemSimulation` Plugin
   - Downloads the correct UE5.7 version of the plugin from Sabri-Kai's GitHub.
3. Clone Modified GAS + NP Plugins
   - Downloads the correct versions of:
     - `GameplayAbilities`
     - `NetworkPrediction`
     - `NetworkPredictionExtras`
     - `NetworkPredictionInsights`
   - All maintained by Sabri-Kai with NPP-compatible modifications.

To run the script:

```bash
powershell.exe Scripts/plugin-setup.ps1
```

> If you are using Command Prompt, Git Bash, or another terminal, make sure to call the script explicitly with `powershell.exe`.

### After Running the Script

Open the project file:

```bash
NetPredictionGAS5_5.uproject
```

Unreal Engine will likely display:

> "The following modules are missing or built with a different engine version ..."

This is normal.
Click Yes to rebuild the modules.
 - If the compile succeeds, UE will open the project.
 - If the compile fails, you may need to build the project from source.

### Possible Issues & Solutions

`ERROR: Could not locate Unreal Engine version UE_5.7 on any drive.`
If Unreal Engine is installed on a non-default drive or custom path, specify the location manually:

```bash
powershell.exe Scripts/plugin-setup.ps1 -UEPathOverride "D:\UE_5.7"
```

`Plugin 'XXXXX' failed to load because module ...`
The script copies plugins directly from your UE installation.
If something is missing:
 - It is missing from your Unreal Engine install - not this project.
 - You must fix your UE installation, then rerun the script to re-copy the plugins.

## References

 - https://github.com/Sabri-Kai/UnrealEngineNPP/tree/GAS-NPP-5.7
 - https://github.com/Sabri-Kai/GAS_NPP_Example
 - https://github.com/Sabri-Kai/GAS-NPP-Simulation

## Need Help?

Join the community Discord: https://discord.gg/umy6rP92JE
