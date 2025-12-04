# ===============================
# Unreal Engine Plugin Fetch Script (Windows Only)
# ===============================

# Ensure script runs from project root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location "$ScriptDir/.."

# -------------------------------
# CONFIGURATION
# -------------------------------
$UERepo = "https://github.com/EpicGames/UnrealEngine.git"
$UEBranch = "release"
$UEPath = "External/UE"

# List of plugins from UE
$Plugins = @(
	"Engine/Plugins/Animation/PoseSearch",
	"Engine/Plugins/Experimental/ChaosMover",
	"Engine/Plugins/Runtime/DataRegistry",
	"Engine/Plugins/Chooser",
	"Engine/Plugins/Editor/GameplayTagsEditor",
	"Engine/Plugins/Runtime/MassGameplay",
	"Engine/Plugins/Runtime/SmartObjects",
	"Engine/Plugins/Experimental/GameplayTargetingSystem",
	"Engine/Plugins/Experimental/Mover",
	"Engine/Plugins/Experimental/MoverExamples",
	"Engine/Plugins/Experimental/MoverIntegrations"
)

Write-Host "=== Fetching Unreal Engine plugins into $UEPath ==="

# -------------------------------
# CLONE UE SHALLOW + SPARSE
# -------------------------------
if (-Not (Test-Path $UEPath)) {
    git clone `
        --filter=blob:none `
        --no-checkout `
        --depth 1 `
        --branch $UEBranch `
        $UERepo `
        $UEPath
}

# Enter UE folder
Set-Location $UEPath

# Enable sparse checkout
git sparse-checkout init --cone

# Apply plugin list to sparse checkout
$Plugins | git sparse-checkout set --stdin

# Checkout the branch (downloads ONLY the plugins)
git checkout $UEBranch

# Return to project root
Set-Location ../..

# -------------------------------
# COPY PLUGINS INTO PROJECT ROOT
# -------------------------------
foreach ($PluginPath in $Plugins) {

    $PluginName = Split-Path $PluginPath -Leaf
    $Source = "External/UE/$PluginPath"
    $Destination = "Plugins/$PluginName"

    Write-Host "Copying $PluginName into project Plugins folder..."

    # Remove destination if it exists (clean copy)
    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }

    # Copy the plugin
    Copy-Item -Recurse -Force $Source $Destination
}

# -------------------------------
# FETCH GAS-NPP-Simulation plugin
# -------------------------------

$GasRepo = "https://github.com/Sabri-Kai/GAS-NPP-Simulation.git"
$GasPath = "External/GAS-NPP-Simulation"
$GasPluginSource = "$GasPath/AbilitySystemSimulation"
$GasPluginDestination = "Plugins/AbilitySystemSimulation"

Write-Host "`n=== Fetching GAS-NPP-Simulation plugin ==="

# Clone the repo only if it doesn't exist
if (-not (Test-Path $GasPath)) {
    git clone `
        --depth 1 `
        $GasRepo `
        $GasPath
}

# Copy it into the Plugins folder
if (Test-Path $GasPluginDestination) {
    Remove-Item -Recurse -Force $GasPluginDestination
}

Copy-Item -Recurse -Force $GasPluginSource $GasPluginDestination

Write-Host "GAS plugin installed at: $GasPluginDestination"

# -------------------------------
# FETCH UnrealEngineNPP (4 plugins)
# -------------------------------

$NppRepo = "https://github.com/Sabri-Kai/UnrealEngineNPP.git"
$NppBranch = "GAS-NPP-5.5"
$NppPath = "External/UnrealEngineNPP"

# Plugin folders from the repo
$NppPlugins = @(
    "GameplayAbilities",
    "NetworkPrediction",
    "NetworkPredictionExtras",
    "NetworkPredictionInsights"
)

Write-Host "`n=== Fetching UnrealEngineNPP plugins ==="

# Clone repo only if not already present
if (-not (Test-Path $NppPath)) {
    git clone `
        --depth 1 `
        --branch $NppBranch `
        $NppRepo `
        $NppPath
}

# Copy each plugin into YourProject/Plugins/
foreach ($PluginName in $NppPlugins) {

    $Source = "$NppPath/$PluginName"
    $Destination = "Plugins/$PluginName"

    Write-Host "Copying $PluginName into project Plugins folder..."

    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }

    Copy-Item -Recurse -Force $Source $Destination
}

Write-Host "=== UnrealEngineNPP plugins installed. ==="
Write-Host "=== DONE: UE plugins installed & copied successfully. ==="
