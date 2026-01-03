# Session Start Checklist

**Last Updated:** 2026-01-03

## ✅ PRE-SESSION VERIFICATION (Before opening new chat)

### 1. **System Ready**
- [ ] Computer restarted (if needed)
- [ ] Google Drive synced (if using for backup)
- [ ] Obsidian closed (avoid file conflicts)

### 2. **Open Project**
```bash
cd "C:\Claude Code Projects\Projects\Koding"
claude-code chat
```

---

## 📊 SYSTEM ARCHITECTURE - Verified Working

### **Folder Structure** ✅
```
C:\Claude Code Projects\
├── .claude/                      # Global Claude Code settings
│   ├── settings.json             # ✅ Statusline fixed (uses Git Bash)
│   └── statusline.sh             # ✅ Status bar script
│
├── MCPs/
│   └── basic-memory/             # ✅ Documentation repo
│       ├── .git                  # → github.com/emircenga-cmd/basic-memory
│       └── README.md
│
└── Projects/
    └── Koding/                   # ✅ Main development project
        ├── .git                  # → github.com/emircenga-cmd/Koding
        ├── CLAUDE.md
        ├── README.md
        ├── .claude/              # Project-specific config
        │   ├── agents/
        │   ├── hooks/
        │   ├── skills/
        │   └── settings.local.json
        └── docs/                 # Documentation
            ├── WUFF-MASTER-BLUEPRINT-v1.0.md
            ├── WUFF-IMPLEMENTATION-CHECKLIST.md
            ├── PROJECT_MEMORY.md
            ├── CLICKUP-STRUCTURE-ANALYSIS.md
            ├── BACKUP-AND-RECOVERY-GUIDE.md
            └── SESSION-START-CHECKLIST.md (this file)
```

---

### **MCP basic-memory Setup** ✅

**Server Location:**
- `C:\Users\emirv\.basic-memory\` (config + SQLite database)

**Storage Locations (from config.json):**
```json
{
  "projects": {
    "wuffuniversum-vault": "C:\\WuffUniversuM\\Basic Memory i Obsidian\\WuffUniversuM Vault",
    "emir-vault": "C:\\WuffUniversuM\\Basic Memory i Obsidian\\EmirVault"
  },
  "default_project": "wuffuniversum-vault"
}
```

**What This Means:**
- ✅ MCP stores notes in `WuffUniversuM Vault` (default)
- ✅ Synced with Obsidian vault
- ✅ 7 markdown files currently stored
- ✅ `Emir Vault` is separate (different MCP)

**Verification:**
```bash
# Check MCP config
cat "C:\Users\emirv\.basic-memory\config.json"

# Count notes in vault
ls "C:\WuffUniversuM\Basic Memory i Obsidian\WuffUniversuM Vault"/*.md | wc -l
```

---

### **GitHub Repositories** ✅

| Repo | Purpose | URL |
|------|---------|-----|
| **Koding** | Development & technical support | https://github.com/emircenga-cmd/Koding |
| **basic-memory** | MCP documentation & backup scripts | https://github.com/emircenga-cmd/basic-memory |
| **obsidian-vaults** | Obsidian vault backups | https://github.com/emircenga-cmd/obsidian-vaults |

**Removed (cleaned up):**
- ❌ claude-projects-master
- ❌ claude-code
- ❌ Claude
- ❌ -n8n-multi-agent-system

---

### **Git Configuration** ✅

**Koding Project:**
```bash
cd "C:\Claude Code Projects\Projects\Koding"
git remote -v
# → origin  https://github.com/emircenga-cmd/Koding.git
```

**Basic-memory Docs:**
```bash
cd "C:\Claude Code Projects\MCPs\basic-memory"
git remote -v
# → origin  https://github.com/emircenga-cmd/basic-memory.git
```

---

## 🔧 CLAUDE CODE SETTINGS - Verified

### **Statusline Configuration** ✅ FIXED

**File:** `C:\Users\emirv\.claude\settings.json`
```json
{
  "alwaysThinkingEnabled": true,
  "statusLine": {
    "type": "command",
    "command": "C:\\Program Files\\Git\\bin\\bash.exe",
    "args": ["C:\\Users\\emirv\\.claude\\statusline.sh"],
    "padding": 0
  }
}
```

**What Was Fixed:**
- ❌ Before: Tried to run `.sh` directly → Windows opened VS Code popup hell
- ✅ After: Uses Git Bash explicitly → Works in chat status bar

**Expected Behavior:**
Status bar shows at bottom of chat:
```
[Sonnet 4.5] 🟢 45% | 💰 $0.15 | ⏱️ 5m | 📝 +120 | 📁 Koding
```

---

## 🎯 FIRST SESSION ACTIONS

When you start new Claude Code chat session:

### 1. **Verify Statusline Works**
- Check bottom of chat for status bar
- If you see VS Code popup → statusline not fixed (shouldn't happen now)

### 2. **Test MCP Server**
```
Ask Claude: "Can you list what's in the wuffuniversum vault?"
Expected: Claude uses MCP to show vault contents
```

### 3. **Check Project Context**
```
Ask Claude: "What is this project about?"
Expected: Claude reads CLAUDE.md and explains it's dev/support for WUFF Orchestrator
```

---

## 🚨 TROUBLESHOOTING

### **Statusline Shows VS Code Popup**
**Problem:** Git Bash path is wrong or settings reverted
**Fix:**
```bash
# Edit settings
code "C:\Users\emirv\.claude\settings.json"

# Ensure it has:
"command": "C:\\Program Files\\Git\\bin\\bash.exe",
"args": ["C:\\Users\\emirv\\.claude\\statusline.sh"]
```

### **MCP Server Not Working**
**Problem:** basic-memory not responding
**Fix:**
```bash
# Check MCP logs
cat "C:\Users\emirv\AppData\Roaming\Claude\logs\mcp-server-basic-memory.log"

# Verify config
cat "C:\Users\emirv\.basic-memory\config.json"
```

### **Git Push Fails**
**Problem:** Remote URL incorrect or auth expired
**Fix:**
```bash
cd "C:\Claude Code Projects\Projects\Koding"

# Check remote
git remote -v

# If wrong, fix:
git remote set-url origin https://github.com/emircenga-cmd/Koding.git

# Re-authenticate if needed
export PATH="/c/Program Files/GitHub CLI:$PATH"
gh auth login
```

---

## 📝 OPTIONAL CLEANUP (Can Do Later)

### **Remove Old Worktrees**
```bash
rm -rf "C:\Users\emirv\.claude-worktrees"
```
**Why:** Old worktrees from previous Git repo setup (no longer needed)

### **Setup Google Drive Backup**
See: `BACKUP-AND-RECOVERY-GUIDE.md` for automated backup setup

---

## ✅ FINAL CHECKLIST - Everything Working

- [x] Git repos have correct remote URLs
- [x] Claude Code statusline fixed (no more VS Code popups!)
- [x] MCP basic-memory properly configured
- [x] MCP stores in WuffUniversuM Vault (synced with Obsidian)
- [x] GitHub repos cleaned up (3 repos remaining)
- [x] Folder structure clean and organized
- [x] Documentation complete and up to date
- [x] Project purpose clarified (Dev & Support, NOT final orchestrator)

---

**🎉 SYSTEM IS READY FOR NEXT SESSION!**

Open project and start coding:
```bash
cd "C:\Claude Code Projects\Projects\Koding"
claude-code chat
```
