# basic-memory Config Restore Instructions

**Created:** 2026-01-04
**Purpose:** Backup and restore instructions for basic-memory MCP server configuration

---

## What is Backed Up Here?

This folder contains critical configuration files for the `basic-memory` MCP server:

- **config.json** - Main configuration (vault path, sync settings, database backend)
- **.bmignore** - File filtering rules (which files to exclude from indexing)

**NOT backed up:**
- `memory.db` - SQLite database (auto-regenerates from .md files in vault)
- `basic-memory.log` - Logs (not needed for restore)
- `.install_id` - Installation ID (auto-regenerates)

---

## When to Use This Backup

Use this backup if:
1. ✅ Reinstalling Windows/Computer
2. ✅ Setting up basic-memory on new machine
3. ✅ Accidentally deleted/corrupted config files
4. ✅ Need to restore default settings

---

## Restore Procedure

### Prerequisites

1. **Install basic-memory** (if not already installed):
   ```bash
   uvx --python 3.12 basic-memory --version
   # Should show version number
   ```

2. **Verify vault exists:**
   ```bash
   ls "C:\Claude Code Projects\WuffUniversuM-Projects"
   # Should show 00_SYSTEM, Koding, etc.
   ```

---

### Step 1: Backup Current Config (Optional)

If `.basic-memory` folder already exists:

```bash
# Backup current config (just in case)
cp -r "C:\Users\emirv\.basic-memory" "C:\Users\emirv\.basic-memory.OLD"
```

---

### Step 2: Restore Config Files

```bash
# Copy config.json
cp 00_SYSTEM/basic-memory-config-backup/config.json "C:\Users\emirv\.basic-memory\config.json"

# Copy .bmignore
cp 00_SYSTEM/basic-memory-config-backup/.bmignore "C:\Users\emirv\.basic-memory\.bmignore"
```

---

### Step 3: Update Vault Path (if needed)

If vault path changed, edit `config.json`:

```json
{
  "projects": {
    "wuff-projects": "C:\\NEW\\PATH\\TO\\WuffUniversuM-Projects"
  }
}
```

**Napomena:** Use double backslashes (`\\`) in Windows paths!

---

### Step 4: Regenerate Database

```bash
# Delete old database (if exists)
rm "C:\Users\emirv\.basic-memory\memory.db"

# Restart Claude Desktop/Code
# basic-memory will auto-regenerate memory.db from vault .md files
```

**Important:** Database rebuilds automatically on first run!

---

### Step 5: Verify Setup

**Test in Claude Desktop:**
```
User: "List all markdown files in wuff-projects"

Expected: Claude shows list of .md files from vault
```

**Check MCP connection:**
- Claude Desktop: Settings → MCP Servers → Should see "wuff-projects"
- Claude Code CLI: `.claude/.mcp.json` should list wuff-projects

---

## Configuration Details

### config.json Structure

```json
{
  "env": "dev",
  "projects": {
    "wuff-projects": "C:\\Claude Code Projects\\WuffUniversuM-Projects"
  },
  "default_project": "wuff-projects",
  "default_project_mode": true,
  "log_level": "INFO",
  "database_backend": "sqlite",
  "sync_changes": true,
  "watch_project_reload_interval": 300,
  "cloud_mode": false
}
```

**Key settings:**
- `projects["wuff-projects"]` - Path to vault (UPDATE if moved!)
- `sync_changes: true` - Auto-sync on file changes
- `watch_project_reload_interval: 300` - Check for changes every 5min
- `cloud_mode: false` - Use local storage (not cloud)

---

### .bmignore Rules

**Purpose:** Filter out non-.md files from indexing

**Current rules:**
- Hidden files (`.*`)
- Code files (`*.js`, `*.py`, `*.ts`, etc.)
- Build artifacts (`dist/`, `node_modules/`, etc.)
- Git folders (`.git/`)
- Obsidian config (`.obsidian/`)

**Result:** Only `.md` files are indexed!

---

## Troubleshooting

### Problem: "No notes found" after restore

**Solution:**
1. Check vault path in `config.json`
2. Verify vault folder exists
3. Delete `memory.db` and restart (rebuilds index)

---

### Problem: Code files being indexed

**Solution:**
1. Check `.bmignore` has all code file extensions
2. Delete `memory.db`
3. Restart Claude Desktop/Code

---

### Problem: Changes not syncing

**Solution:**
1. Check `config.json` → `"sync_changes": true`
2. Wait 5 minutes (watch interval)
3. Restart Claude Desktop/Code for immediate sync

---

## Related Documentation

- `00_SYSTEM/BASIC-MEMORY-MASTER-GUIDE.md` - Complete basic-memory documentation
- `00_SYSTEM/MCP-BASIC-MEMORY-SETUP.md` - Initial setup guide
- Official: https://github.com/cktang88/basic-memory

---

## Backup Location

**This backup is stored in:**
```
C:\Claude Code Projects\WuffUniversuM-Projects\00_SYSTEM\basic-memory-config-backup\
```

**Git repo:** WuffUniversuM-Projects (version controlled)

**Created:** 2026-01-04 (before GitHub cleanup)

---

**Last Updated:** 2026-01-04
