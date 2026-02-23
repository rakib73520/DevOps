# 🌿 Git Branching

> Branches let you work on features or fixes in isolation without touching the main codebase.

---

## Core Concept

```
main        ●────────────────────────────────●
                 \                          /
feature-login     ●────●────●────●────●────
```

- `main` is your stable, production-ready branch
- You create a new branch for each feature or bug fix
- When done, you merge it back into `main`

---

## Creating & Switching Branches

```bash
# See all branches (* = current branch)
git branch

# See all branches including remote
git branch -a

# Create a new branch
git branch feature-login

# Switch to a branch
git switch feature-login

# Create AND switch in one step (recommended)
git switch -c feature-login

# Old way (still works)
git checkout -b feature-login
```

---

## Working on a Branch

```bash
# 1. Create and switch to new branch
git switch -c feature-login

# 2. Make your changes, then stage and commit as normal
git add .
git commit -m "add login page"

# 3. Push branch to GitHub
git push -u origin feature-login
```

---

## Merging a Branch

```bash
# 1. Switch to the branch you want to merge INTO (usually main)
git switch main

# 2. Pull latest to make sure main is up to date
git pull origin main

# 3. Merge your feature branch
git merge feature-login
```

### Merge Commit vs Fast-Forward

```bash
# Fast-forward (no extra commit, clean history)
git merge feature-login

# Merge commit (preserves that a branch existed)
git merge --no-ff feature-login
```

> 💡 Teams usually use `--no-ff` so the history shows when features were merged.

---

## Deleting a Branch

```bash
# Delete local branch (after merging)
git branch -d feature-login

# Force delete (even if not merged)
git branch -D feature-login

# Delete remote branch on GitHub
git push origin --delete feature-login
```

---

## Merge Conflicts

A conflict happens when two branches change the same line of a file.

```bash
# Git will mark the conflict in the file like this:
<<<<<<< HEAD (your current branch)
  const name = "Alice"
=======
  const name = "Bob"
>>>>>>> feature-login (incoming branch)
```

**To resolve:**
1. Open the file and manually pick the correct version
2. Delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. Stage and commit the resolved file:

```bash
git add file.txt
git commit -m "resolve merge conflict"
```

> 💡 VS Code highlights conflicts visually and lets you click "Accept Current" or "Accept Incoming".

---

## Quick Reference

| Command | What It Does |
|---------|-------------|
| `git branch` | List local branches |
| `git switch -c <name>` | Create + switch to new branch |
| `git switch <name>` | Switch to existing branch |
| `git merge <branch>` | Merge branch into current |
| `git branch -d <name>` | Delete local branch |
| `git push origin --delete <name>` | Delete remote branch |
