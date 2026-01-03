# ========================================
# PREPARE FOR RENAME SCRIPT
# Closes all apps before folder rename
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Preparing System for Rename" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# ========================================
# STEP 1: Close Claude Desktop
# ========================================

Write-Host "[1/4] Closing Claude Desktop..." -ForegroundColor Yellow

$claudeDesktop = Get-Process -Name "Claude" -ErrorAction SilentlyContinue

if ($claudeDesktop) {
    $claudeDesktop | Stop-Process -Force
    Write-Host "✅ Claude Desktop closed" -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "ℹ️  Claude Desktop not running" -ForegroundColor Cyan
}

# ========================================
# STEP 2: Close Obsidian
# ========================================

Write-Host "`n[2/4] Closing Obsidian..." -ForegroundColor Yellow

$obsidian = Get-Process -Name "Obsidian" -ErrorAction SilentlyContinue

if ($obsidian) {
    $obsidian | Stop-Process -Force
    Write-Host "✅ Obsidian closed" -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "ℹ️  Obsidian not running" -ForegroundColor Cyan
}

# ========================================
# STEP 3: Wait for file locks to release
# ========================================

Write-Host "`n[3/4] Waiting for file locks to release..." -ForegroundColor Yellow

Start-Sleep -Seconds 3

Write-Host "✅ File locks released" -ForegroundColor Green

# ========================================
# STEP 4: Verify folder is accessible
# ========================================

Write-Host "`n[4/4] Verifying folder accessibility..." -ForegroundColor Yellow

$oldPath = "C:\Claude Code Projects\Projects"

if (Test-Path $oldPath) {
    Write-Host "✅ Folder found and accessible" -ForegroundColor Green
} else {
    Write-Host "❌ ERROR: Folder not found at $oldPath" -ForegroundColor Red
    exit 1
}

# ========================================
# READY FOR RENAME
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  READY FOR RENAME!" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Applications closed:" -ForegroundColor Green
Write-Host "  ✅ Claude Desktop" -ForegroundColor White
Write-Host "  ✅ Obsidian" -ForegroundColor White
Write-Host "  ✅ File locks released`n" -ForegroundColor White

Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Manually rename folder in File Explorer:" -ForegroundColor White
Write-Host "   $oldPath" -ForegroundColor Gray
Write-Host "   → C:\Claude Code Projects\WuffUniversuM-Projects`n" -ForegroundColor Gray

Write-Host "2. After rename, run:" -ForegroundColor White
Write-Host "   cd `"C:\Claude Code Projects\WuffUniversuM-Projects\00_SYSTEM`"" -ForegroundColor Gray
Write-Host "   .\FINISH-SETUP.ps1`n" -ForegroundColor Gray

Write-Host "This PowerShell window will close in 5 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
