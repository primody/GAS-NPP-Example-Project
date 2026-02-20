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
$GasBranch = "GAS-NPP-Simulation-5.7"
$GasPath = "External/GAS-NPP-Simulation"
$GasPluginSource = "$GasPath/AbilitySystemSimulation"
$GasPluginDestination = "Plugins/AbilitySystemSimulation"

Write-Host "`n=== Fetching GAS-NPP-Simulation plugin ($GasBranch) ==="

# Always remove old repo (deterministic builds)
if (Test-Path $GasPath) {
    Write-Host "Removing existing GAS repo..."
    Remove-Item -Recurse -Force $GasPath
}

# Fresh shallow clone of the branch
git clone `
    --depth 1 `
    --branch $GasBranch `
    --single-branch `
    $GasRepo `
    $GasPath

# Copy plugin
if (Test-Path $GasPluginDestination) {
    Remove-Item -Recurse -Force $GasPluginDestination
}

Copy-Item -Recurse -Force $GasPluginSource $GasPluginDestination

Write-Host "GAS plugin installed at: $GasPluginDestination"

# -------------------------------
# FETCH UnrealEngineNPP (4 plugins)
# -------------------------------

$NppRepo = "https://github.com/Sabri-Kai/UnrealEngineNPP.git"
$NppBranch = "GAS-NPP-5.7"
$NppPath = "External/UnrealEngineNPP"

$NppPlugins = @(
    "GameplayAbilities",
    "NetworkPrediction",
    "NetworkPredictionExtras",
    "NetworkPredictionInsights"
)

Write-Host "`n=== Fetching UnrealEngineNPP plugins ($NppBranch) ==="

# Always remove old repo (prevents wrong branch issues)
if (Test-Path $NppPath) {
    Write-Host "Removing existing UnrealEngineNPP repo..."
    Remove-Item -Recurse -Force $NppPath
}

# Fresh shallow clone of correct branch
git clone `
    --depth 1 `
    --branch $NppBranch `
    --single-branch `
    $NppRepo `
    $NppPath

# Copy plugins
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
