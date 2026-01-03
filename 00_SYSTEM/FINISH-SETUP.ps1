# ========================================
# FINISH SETUP SCRIPT
# Auto-completes WuffUniversuM-Projects rename
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  WuffUniversuM-Projects Final Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"

# ========================================
# STEP 1: Verify Folder Rename
# ========================================

Write-Host "[1/7] Verifying folder rename..." -ForegroundColor Yellow

$oldPath = "C:\Claude Code Projects\Projects"
$newPath = "C:\Claude Code Projects\WuffUniversuM-Projects"

if (Test-Path $newPath) {
    Write-Host "✅ Folder renamed successfully: WuffUniversuM-Projects" -ForegroundColor Green
} elseif (Test-Path $oldPath) {
    Write-Host "❌ ERROR: Folder not renamed yet!" -ForegroundColor Red
    Write-Host "Please rename manually:" -ForegroundColor Yellow
    Write-Host "  $oldPath" -ForegroundColor Yellow
    Write-Host "  → $newPath`n" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "❌ ERROR: Neither old nor new folder found!" -ForegroundColor Red
    exit 1
}

# ========================================
# STEP 2: Update basic-memory Config
# ========================================

Write-Host "`n[2/7] Updating basic-memory config..." -ForegroundColor Yellow

$bmConfigPath = "$env:USERPROFILE\.basic-memory\config.json"

if (Test-Path $bmConfigPath) {
    $bmConfig = Get-Content $bmConfigPath -Raw | ConvertFrom-Json

    # Update path
    $bmConfig.projects.'wuff-projects' = "C:\Claude Code Projects\WuffUniversuM-Projects"

    # Save
    $bmConfig | ConvertTo-Json -Depth 10 | Set-Content $bmConfigPath

    Write-Host "✅ basic-memory config updated" -ForegroundColor Green
} else {
    Write-Host "⚠️  WARNING: basic-memory config not found at $bmConfigPath" -ForegroundColor Yellow
}

# ========================================
# STEP 3: Update Backup Scripts
# ========================================

Write-Host "`n[3/7] Updating backup scripts..." -ForegroundColor Yellow

# Update auto-backup-projects.ps1
$backupScriptPath = "$newPath\00_SYSTEM\auto-backup-projects.ps1"

if (Test-Path $backupScriptPath) {
    $backupScript = Get-Content $backupScriptPath -Raw

    # Replace old paths
    $backupScript = $backupScript -replace 'C:\\Claude Code Projects\\Projects\\Koding', 'C:\Claude Code Projects\WuffUniversuM-Projects'
    $backupScript = $backupScript -replace 'C:\\Claude Code Projects\\Projects\\00_SYSTEM', 'C:\Claude Code Projects\WuffUniversuM-Projects\00_SYSTEM'

    Set-Content $backupScriptPath $backupScript

    Write-Host "✅ auto-backup-projects.ps1 updated" -ForegroundColor Green
} else {
    Write-Host "⚠️  WARNING: Backup script not found" -ForegroundColor Yellow
}

# Update setup-auto-backup-task.ps1
$setupScriptPath = "$newPath\00_SYSTEM\setup-auto-backup-task.ps1"

if (Test-Path $setupScriptPath) {
    $setupScript = Get-Content $setupScriptPath -Raw

    # Replace old paths
    $setupScript = $setupScript -replace 'C:\\Claude Code Projects\\Projects', 'C:\Claude Code Projects\WuffUniversuM-Projects'

    Set-Content $setupScriptPath $setupScript

    Write-Host "✅ setup-auto-backup-task.ps1 updated" -ForegroundColor Green
} else {
    Write-Host "⚠️  WARNING: Setup script not found" -ForegroundColor Yellow
}

# ========================================
# STEP 4: Delete Old Backup Task
# ========================================

Write-Host "`n[4/7] Removing old backup task..." -ForegroundColor Yellow

try {
    $oldTask = Get-ScheduledTask -TaskName "ObsidianVaultsAutoBackup" -ErrorAction SilentlyContinue

    if ($oldTask) {
        Unregister-ScheduledTask -TaskName "ObsidianVaultsAutoBackup" -Confirm:$false
        Write-Host "✅ Old backup task removed" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  Old backup task not found (already removed)" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  WARNING: Could not remove old task (may need admin rights)" -ForegroundColor Yellow
    Write-Host "   Run this in Admin PowerShell if needed:" -ForegroundColor Yellow
    Write-Host "   Unregister-ScheduledTask -TaskName 'ObsidianVaultsAutoBackup' -Confirm:`$false`n" -ForegroundColor Gray
}

# ========================================
# STEP 5: Create New Backup Task
# ========================================

Write-Host "`n[5/7] Setting up new backup task..." -ForegroundColor Yellow

try {
    $taskName = "ProjectsAutoBackup"
    $scriptPath = "$newPath\00_SYSTEM\auto-backup-projects.ps1"

    # Remove existing if exists
    $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }

    # Create action
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
        -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

    # Create trigger - every 5 hours
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 5)

    # Create principal
    $principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest

    # Create settings
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    # Register task
    Register-ScheduledTask -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Description "Auto-backup WuffUniversuM-Projects to GitHub every 5 hours" | Out-Null

    Write-Host "✅ New backup task created: $taskName" -ForegroundColor Green
    Write-Host "   Frequency: Every 5 hours" -ForegroundColor Cyan
    Write-Host "   Script: $scriptPath" -ForegroundColor Cyan

} catch {
    Write-Host "⚠️  WARNING: Could not create backup task (may need admin rights)" -ForegroundColor Yellow
    Write-Host "   Run this script as Administrator to setup auto-backup`n" -ForegroundColor Yellow
}

# ========================================
# STEP 6: Reset basic-memory Database
# ========================================

Write-Host "`n[6/7] Resetting basic-memory database..." -ForegroundColor Yellow

$memoryDbPath = "$env:USERPROFILE\.basic-memory\memory.db"

if (Test-Path $memoryDbPath) {
    try {
        Remove-Item $memoryDbPath -Force
        Write-Host "✅ memory.db deleted (will be recreated on next Claude Desktop start)" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  WARNING: Could not delete memory.db (may be in use)" -ForegroundColor Yellow
        Write-Host "   Close Claude Desktop and delete manually if needed" -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ️  memory.db not found (will be created on first use)" -ForegroundColor Cyan
}

# ========================================
# STEP 7: Verification
# ========================================

Write-Host "`n[7/7] Running verification..." -ForegroundColor Yellow

$errors = 0

# Check folder
if (-not (Test-Path $newPath)) {
    Write-Host "❌ Folder not found: $newPath" -ForegroundColor Red
    $errors++
}

# Check basic-memory config
if (Test-Path $bmConfigPath) {
    $bmConfig = Get-Content $bmConfigPath -Raw | ConvertFrom-Json
    $configPath = $bmConfig.projects.'wuff-projects'

    if ($configPath -eq "C:\Claude Code Projects\WuffUniversuM-Projects") {
        Write-Host "✅ basic-memory config points to correct path" -ForegroundColor Green
    } else {
        Write-Host "❌ basic-memory config has wrong path: $configPath" -ForegroundColor Red
        $errors++
    }
}

# Check Git repo
$gitPath = "$newPath\.git"
if (Test-Path $gitPath) {
    Write-Host "✅ Git repo found in root" -ForegroundColor Green
} else {
    Write-Host "❌ Git repo not found in root" -ForegroundColor Red
    $errors++
}

# Check backup task
$backupTask = Get-ScheduledTask -TaskName "ProjectsAutoBackup" -ErrorAction SilentlyContinue
if ($backupTask) {
    Write-Host "✅ Backup task exists: ProjectsAutoBackup" -ForegroundColor Green
} else {
    Write-Host "⚠️  Backup task not found (may need admin rights to create)" -ForegroundColor Yellow
}

# ========================================
# FINAL SUMMARY
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  SETUP COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "✅ All checks passed!" -ForegroundColor Green
} else {
    Write-Host "⚠️  $errors error(s) found - check messages above" -ForegroundColor Yellow
}

Write-Host "`nNEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Restart Claude Desktop (for basic-memory to re-index)" -ForegroundColor White
Write-Host "2. Open new Claude Code session:" -ForegroundColor White
Write-Host "   cd `"C:\Claude Code Projects\WuffUniversuM-Projects`"" -ForegroundColor Gray
Write-Host "   claude-code chat" -ForegroundColor Gray
Write-Host "3. Test basic-memory:" -ForegroundColor White
Write-Host "   'List all markdown files in wuff-projects vault'`n" -ForegroundColor Gray

Write-Host "Documentation: 00_SYSTEM\BASIC-MEMORY-MASTER-GUIDE.md`n" -ForegroundColor Cyan

# ========================================
# OPTIONAL: GitHub Cleanup Prompt
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OPTIONAL CLEANUP" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Old GitHub repos found:" -ForegroundColor Yellow
Write-Host "  - emircenga-cmd/basic-memory (docs - already deleted locally)" -ForegroundColor White
Write-Host "  - emircenga-cmd/obsidian-vaults (vaults - already deleted locally)" -ForegroundColor White

Write-Host "`nTo delete (optional):" -ForegroundColor Cyan
Write-Host "  gh repo delete emircenga-cmd/basic-memory" -ForegroundColor Gray
Write-Host "  gh repo delete emircenga-cmd/obsidian-vaults`n" -ForegroundColor Gray

Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
