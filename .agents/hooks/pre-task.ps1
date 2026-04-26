# pre-task.ps1 — Seguridad pre-ejecución (Windows)
# Invocado por el hook PreToolUse de Claude Code (stdin: JSON payload)
# Exit 2 = bloquear la herramienta | Exit 0 = permitir

param()

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$RawInput = [Console]::In.ReadToEnd()

# Parsear JSON con PowerShell nativo (sin Python, sin interpolación insegura)
$ToolName = "unknown"
$Command  = ""
try {
    $Json    = $RawInput | ConvertFrom-Json
    $ToolName = $Json.tool_name
    $Command  = $Json.tool_input.command
} catch { <# JSON vacío o malformado — continuar con defaults #> }

$ToolName = if ($ToolName) { $ToolName } else { "unknown" }
$Command  = if ($Command)  { $Command  } else { "" }

# ── 1. Bloquear dump completo de variables de entorno ─────────────────────────
if ($ToolName -eq "Bash") {
    if ($Command -match '^\s*(env|printenv|export\s+-p|set)\s*(#.*)?$') {
        Write-Error "BLOCKED: Dumping all environment variables is not allowed (security policy)."
        exit 2
    }

    if ($Command -match '(cat|type|head|tail|less|more|bat)\s+[''"]?[^ ]*\.env([''"\s]|$)') {
        Write-Error "BLOCKED: Reading .env files directly is not allowed (security policy)."
        exit 2
    }

    if ($Command -match '/proc/([0-9]+|self)/environ') {
        Write-Error "BLOCKED: Reading process environment via /proc is not allowed (security policy)."
        exit 2
    }
}

# ── 2. Detectar prompt injection ──────────────────────────────────────────────
$InjectionPattern = 'ignore (all |previous |prior |system )?instructions|disregard (all |previous )?instructions|\[SYSTEM\]|new system prompt|you are now a|forget (all |your |previous )?instructions|jailbreak|DAN mode|override (your |all )?instructions|ignora (todo lo |lo )?anterior|olvida (tus |todas )?instrucciones|act[uú]a como|eres ahora|tu nuevo rol|muestra tus instrucciones|repite tu prompt|\[INST\]|### Instruction:'

if ($RawInput -imatch $InjectionPattern) {
    Write-Error "BLOCKED: Posible prompt injection detectado. Revisa el input antes de continuar."
    exit 2
}

# ── 3. Checks git ─────────────────────────────────────────────────────────────
$gitCheck = git rev-parse --git-dir 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  AVISO: No estás en un repositorio git." -ForegroundColor Yellow
}

$Uncommitted = (git status --porcelain 2>$null | Measure-Object -Line).Lines
if ($Uncommitted -gt 5) {
    Write-Host "⚠️  AVISO: Hay $Uncommitted ficheros con cambios sin commitear." -ForegroundColor Yellow
}

$EnvFiles = git status --porcelain 2>$null | Where-Object { $_ -match '\.env$' }
if ($EnvFiles) {
    Write-Host "⚠️  AVISO: Hay un fichero .env en el working tree. No lo incluyas en el commit." -ForegroundColor Yellow
}

exit 0
