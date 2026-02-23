# 🌍 Git Remote

> How Git talks to GitHub (or any remote server).

---

## What is a Remote?

A **remote** is a version of your repo hosted somewhere else (GitHub, GitLab, etc.).
`origin` is just the default name Git gives to the remote you cloned from.

```bash
# See your remotes
git remote -v

# Output:
# origin  https://github.com/you/repo.git (fetch)
# origin  https://github.com/you/repo.git (push)
```

---

## Managing Remotes

```bash
# Add a remote
git remote add origin https://github.com/you/repo.git

# Change remote URL (e.g. switched from HTTPS to SSH)
git remote set-url origin git@github.com:you/repo.git

# Remove a remote
git remote remove origin

# Rename a remote
git remote rename origin upstream
```

---

## Fetch vs Pull

Both download changes from the remote — but behave differently.

```bash
# Fetch — downloads changes but does NOT merge into your branch
git fetch origin

# Pull — downloads + merges into your current branch
git pull origin main
```

> 💡 Use `fetch` when you want to see what changed remotely before merging.
> Use `pull` when you're ready to update your local branch.

```bash
# See what fetch downloaded before merging
git fetch origin
git diff main origin/main      # compare your local main vs remote main
git merge origin/main          # merge when ready
```

---

## Upstream (Tracking Branch)

An **upstream** links your local branch to a remote branch so you can just run `git push` / `git pull` without specifying origin and branch every time.

```bash
# Set upstream when pushing for the first time
git push -u origin feature-login

# After this, you can just run:
git push
git pull

# Check what upstream is set for each branch
git branch -vv
```

---

## Forking Workflow (Contributing to Others' Repos)

When contributing to a project you don't own:

```bash
# 1. Fork the repo on GitHub (click Fork button)

# 2. Clone YOUR fork
git clone https://github.com/you/their-repo.git

# 3. Add the original repo as "upstream"
git remote add upstream https://github.com/original-owner/their-repo.git

# 4. Keep your fork up to date with the original
git fetch upstream
git merge upstream/main

# 5. Push your changes to YOUR fork
git push origin feature-branch

# 6. Open a Pull Request on GitHub from your fork → their repo
```

---

## SSH vs HTTPS

Two ways to authenticate with GitHub:

| | HTTPS | SSH |
|--|-------|-----|
| **URL format** | `https://github.com/user/repo.git` | `git@github.com:user/repo.git` |
| **Auth method** | Username + token | SSH key pair |
| **Better for** | Quick setup | Daily use (no password prompts) |

**Set up SSH key:**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "you@example.com"

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add it to GitHub: Settings → SSH Keys → New SSH Key → paste it

# Test connection
ssh -T git@github.com
# Hi username! You've successfully authenticated.
```

---

## Quick Reference

| Command | What It Does |
|---------|-------------|
| `git remote -v` | List all remotes |
| `git remote add origin <url>` | Add a remote |
| `git fetch origin` | Download changes (don't merge) |
| `git pull origin main` | Download + merge |
| `git push -u origin <branch>` | Push + set upstream |
| `git branch -vv` | See tracking branches |
