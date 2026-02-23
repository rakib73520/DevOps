# 📦 Git Basics

> Git is a version control system — it tracks changes to your code over time.

---

## Core Concept

```
Working Directory → Staging Area → Local Repo → Remote Repo (GitHub)
   (your files)      (git add)     (git commit)    (git push)
```

---

## Setup (first time only)

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Verify
git config --list
```

---

## Starting a Repo

```bash
# Option A — start fresh in an existing folder
git init

# Option B — copy an existing repo from GitHub
git clone https://github.com/user/repo.git

# Clone into a specific folder name
git clone https://github.com/user/repo.git my-folder
```

---

## Daily Commands

### Check status
```bash
git status        # shows what's changed, staged, or untracked
```

### Stage files
```bash
git add file.txt          # stage a specific file
git add .                 # stage everything in current folder
git add src/              # stage a specific folder
```

### Commit
```bash
git commit -m "your message here"

# Stage + commit tracked files in one step (skips new/untracked files)
git commit -am "your message"
```

### Push to GitHub
```bash
git push                        # push to current branch
git push origin main            # push to specific branch
git push -u origin main         # push + set upstream (first time)
```

### Pull from GitHub
```bash
git pull                        # fetch + merge latest changes
git pull origin main            # pull from specific branch
```

---

## Viewing History

```bash
git log                         # full commit history
git log --oneline               # compact one-line view
git log --oneline --graph       # visual branch graph
git log -5                      # last 5 commits only

git show <commit-hash>          # see what changed in a commit
git diff                        # see unstaged changes
git diff --staged               # see staged changes
```

---

## Undoing Things

```bash
# Unstage a file (keep changes in working directory)
git restore --staged file.txt

# Discard changes in working directory (permanent!)
git restore file.txt

# Undo last commit but keep changes staged
git reset --soft HEAD~1

# Undo last commit and unstage changes
git reset --mixed HEAD~1

# Undo last commit and delete changes (permanent!)
git reset --hard HEAD~1
```

> ⚠️ `--hard` permanently deletes your changes. Use with caution.

---

## .gitignore

Tell Git to ignore certain files (secrets, build output, dependencies):

```bash
# Create a .gitignore file
touch .gitignore
```

Example `.gitignore`:
```
node_modules/
.env
*.log
dist/
.DS_Store
```

> 💡 Add `.gitignore` before your first commit so ignored files are never tracked.

---

## Quick Reference

| Command | What It Does |
|---------|-------------|
| `git init` | Start a new repo |
| `git clone <url>` | Copy a remote repo |
| `git status` | See what's changed |
| `git add .` | Stage all changes |
| `git commit -m ""` | Save a snapshot |
| `git push` | Upload to GitHub |
| `git pull` | Download latest changes |
| `git log --oneline` | View commit history |
