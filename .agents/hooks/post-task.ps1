# post-task.ps1 — Acciones tras completar una tarea (Windows)
# Invocado por el hook Stop de Claude Code

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Changed = (git status --porcelain 2>$null | Measure-Object -Line).Lines

Write-Host "[$Timestamp] post-task: tarea completada"

if ($Changed -gt 0) {
    Write-Host ""
    Write-Host "📝 Ficheros modificados ($Changed):"
    git status --short 2>$null
    Write-Host ""
    Write-Host "💡 Sugerencia: cuando quieras commitear, usa Conventional Commits:"
    Write-Host "   feat(scope): descripción"
    Write-Host "   fix(scope): descripción"
}

exit 0
