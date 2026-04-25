# install.ps1 — Instala el sistema multi-agente en un proyecto destino
#
# Uso:
#   .\install.ps1 -Target C:\ruta\al\proyecto
#   .\install.ps1 -Target C:\ruta\al\proyecto -Force

param(
    [Parameter(Mandatory=$false)]
    [string]$Target,
    [switch]$Force,
    [switch]$Help
)

if ($Help -or -not $Target) {
    Write-Host "Sistema Multi-Agente - Instalador" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Uso:"
    Write-Host "  .\install.ps1 -Target C:\ruta\al\proyecto"
    Write-Host "  .\install.ps1 -Target C:\ruta\al\proyecto -Force"
    exit 0
}

$Source = $PSScriptRoot

Write-Host "Sistema Multi-Agente - Instalador" -ForegroundColor Blue
Write-Host "Origen : $Source"
Write-Host "Destino: $Target"
Write-Host ""

if (-not (Test-Path $Target -PathType Container)) {
    Write-Host "x El directorio destino no existe: $Target" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "$Source\.agents")) {
    Write-Host "x No se encuentra .agents/ en el origen." -ForegroundColor Red
    exit 1
}

function Copy-Safe {
    param([string]$Src, [string]$Dst)
    $name = Split-Path $Dst -Leaf
    if ((Test-Path $Dst) -and -not $Force) {
        Write-Host "  ~ omitido (ya existe): $name" -ForegroundColor Yellow
    } else {
        Copy-Item $Src $Dst -Recurse -Force
        Write-Host "  + $name" -ForegroundColor Green
    }
}

# ── 1. Carpeta .agents/
Write-Host "Copiando sistema de agentes..."
$agentsDst = Join-Path $Target ".agents"
if ((Test-Path $agentsDst) -and -not $Force) {
    Write-Host "  ~ omitido (ya existe): .agents/  (-Force para sobreescribir)" -ForegroundColor Yellow
} else {
    Copy-Item "$Source\.agents" $agentsDst -Recurse -Force
    $count = (Get-ChildItem "$Source\.agents" -Recurse -File).Count
    Write-Host "  + .agents/ ($count ficheros)" -ForegroundColor Green
}

# ── 2. Manifests multi-LLM
Write-Host ""
Write-Host "Copiando manifests multi-LLM..."

Copy-Safe "$Source\AGENTS.md"    "$Target\AGENTS.md"
Copy-Safe "$Source\CLAUDE.md"    "$Target\CLAUDE.md"
Copy-Safe "$Source\opencode.json" "$Target\opencode.json"

New-Item -ItemType Directory -Force -Path "$Target\.github" | Out-Null
Copy-Safe "$Source\.github\copilot-instructions.md" "$Target\.github\copilot-instructions.md"

# ── 3. Ficheros de configuración opcionales
Write-Host ""
Write-Host "Copiando configuracion..."
Copy-Safe "$Source\.env.example" "$Target\.env.example"

# ── 4. Resumen
Write-Host ""
Write-Host "Instalacion completada" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos pasos:"
Write-Host "  1. Copia .env.example a .env y rellena tus tokens"
Write-Host "  2. Personaliza AGENTS.md con el nombre y proposito del proyecto"
Write-Host "  3. Edita .agents\shared\resources\conventions.md con las convenciones del proyecto"
Write-Host ""
Write-Host "Para activar el sistema en tu LLM:" -ForegroundColor Cyan
Write-Host "  'Carga .agents/MANIFEST.md y actua como orquestador'" -ForegroundColor Cyan
