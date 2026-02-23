# ⚡ Git Advanced

> Power tools for cleaner history, flexible workflows, and fixing mistakes.

---

## Git Rebase

Rebase moves your branch's commits on top of another branch — giving a **cleaner, linear history** compared to merge.

```
Before rebase:
main      ●────●────●
               \
feature         ●────●────●

After rebase:
main      ●────●────●
                         \
feature                   ●────●────● (replayed on top of latest main)
```

```bash
# Update your feature branch with latest main (instead of merging)
git switch feature-login
git rebase main

# If conflicts occur during rebase:
# 1. Fix the conflict in the file
# 2. Stage it
git add file.txt
# 3. Continue
git rebase --continue

# Abort and go back to before rebase
git rebase --abort
```

> ⚠️ Never rebase a branch that others are working on — it rewrites commit history and causes problems for teammates.

---

## Interactive Rebase (Cleaning Up Commits)

Lets you edit, squash, reorder, or delete commits before merging.

```bash
# Rewrite last 3 commits interactively
git rebase -i HEAD~3
```

An editor opens with your commits listed:

```
pick a1b2c3 add login page
pick d4e5f6 fix typo
pick g7h8i9 wip
```

Change `pick` to:

| Option | What It Does |
|--------|-------------|
| `pick` | Keep commit as-is |
| `squash` / `s` | Combine with previous commit |
| `reword` / `r` | Keep commit but edit the message |
| `drop` / `d` | Delete the commit entirely |

> 💡 Use squash to turn 10 messy "wip" commits into 1 clean commit before opening a PR.

---

## Git Stash

Temporarily save your uncommitted work so you can switch branches or pull without losing changes.

```bash
# Save current changes to stash
git stash

# Save with a description
git stash push -m "half-done login form"

# List all stashes
git stash list

# Bring back the latest stash (keeps it in stash list)
git stash apply

# Bring back latest stash and remove it from list
git stash pop

# Apply a specific stash
git stash apply stash@{2}

# Delete a stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

**Common use case:**
```bash
# You're mid-feature but need to quickly fix a bug on main
git stash                  # save your work
git switch main            # go to main
git switch -c hotfix-123   # fix the bug
# ... fix and commit ...
git switch feature-login   # back to your feature
git stash pop              # restore your work
```

---

## Git Cherry-Pick

Copy a specific commit from one branch and apply it to another — without merging the whole branch.

```bash
# Get the commit hash from git log
git log --oneline

# Apply that commit to your current branch
git cherry-pick a1b2c3

# Cherry-pick multiple commits
git cherry-pick a1b2c3 d4e5f6

# Cherry-pick without auto-committing (lets you edit first)
git cherry-pick a1b2c3 --no-commit
```

**Common use case:**
> A bug fix was committed to `feature-x` but you need it in `main` right now, without merging all of `feature-x`.

---

## Git Reset vs Revert

Both undo changes — but in different ways.

```bash
# Reset — rewrites history (use on local/private branches only)
git reset --soft HEAD~1    # undo commit, keep changes staged
git reset --mixed HEAD~1   # undo commit, unstage changes (default)
git reset --hard HEAD~1    # undo commit, delete changes permanently ⚠️

# Revert — creates a NEW commit that undoes a previous one (safe for shared branches)
git revert a1b2c3          # reverts that specific commit
git revert HEAD            # reverts the latest commit
```

> ✅ Use `revert` on `main` or shared branches — it doesn't rewrite history.
> ⚠️ Use `reset` only on your own local/private branches.

---

## Git Reflog (Your Safety Net)

Reflog records every action Git has taken — even resets and rebases. Use it to recover lost commits.

```bash
git reflog                 # see full history of HEAD movements

# Recover a lost commit
git reflog                 # find the hash of what you lost
git reset --hard a1b2c3    # go back to it
```

> 💡 If you accidentally `--hard` reset and lost work, `git reflog` can almost always get it back.

---

## Git Tags

Mark specific commits as releases or milestones.

```bash
# Create a tag
git tag v1.0.0

# Create an annotated tag (with message)
git tag -a v1.0.0 -m "first production release"

# Push tags to GitHub
git push origin v1.0.0
git push --tags             # push all tags

# List tags
git tag

# Delete a tag
git tag -d v1.0.0
git push origin --delete v1.0.0
```

---

## Quick Reference

| Command | What It Does |
|---------|-------------|
| `git rebase main` | Replay your branch on top of main |
| `git rebase -i HEAD~3` | Interactively edit last 3 commits |
| `git stash` | Temporarily save uncommitted work |
| `git stash pop` | Restore stashed work |
| `git cherry-pick <hash>` | Copy a specific commit to current branch |
| `git revert <hash>` | Safely undo a commit (keeps history) |
| `git reset --hard HEAD~1` | Undo commit + delete changes ⚠️ |
| `git reflog` | See full history — recover lost work |
| `git tag v1.0.0` | Mark a commit as a release |
