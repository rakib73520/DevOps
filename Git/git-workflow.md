# 🔄 Git Workflow — Real World

> How teams actually use Git day-to-day. Follow this pattern for every feature or fix.

---

## The Standard Feature Branch Workflow

```
main (production)
 │
 ├── develop (integration branch)
 │       │
 │       ├── feature/login
 │       ├── feature/dashboard
 │       └── bugfix/header-crash
```

- **`main`** — live production code. Never commit directly here.
- **`develop`** — integration branch. Features get merged here first.
- **`feature/*`** — one branch per feature or task.
- **`bugfix/*`** — one branch per bug fix.
- **`hotfix/*`** — urgent fix that goes straight to main.

---

## Day-to-Day Flow

### Starting a New Feature

```bash
# 1. Make sure you're on develop and it's up to date
git switch develop
git pull origin develop

# 2. Create a feature branch
git switch -c feature/user-login

# 3. Write code, commit often
git add .
git commit -m "add login form UI"
git commit -m "add form validation"
git commit -m "connect login to API"

# 4. Push your branch to GitHub
git push -u origin feature/user-login
```

---

### Keeping Your Branch Up to Date

While you're working, `develop` may move forward. Update your branch regularly:

```bash
git switch develop
git pull origin develop
git switch feature/user-login
git rebase develop        # replay your commits on top of latest develop
```

> 📄 See `git-advanced.md` for rebase details.

---

### Opening a Pull Request (PR)

1. Push your branch to GitHub
2. Go to GitHub → your repo → **"Compare & pull request"**
3. Set base branch: `develop`, compare: `feature/user-login`
4. Write a description of what changed and why
5. Request a review from a teammate
6. Fix any review comments → push again (PR updates automatically)
7. Once approved → **Merge**

> 💡 Squash your commits before opening a PR to keep history clean.
> See `git-advanced.md → Interactive Rebase`.

---

### After PR is Merged

```bash
# Clean up your local branch
git switch develop
git pull origin develop          # get the merged changes
git branch -d feature/user-login # delete local branch
git push origin --delete feature/user-login  # delete remote branch
```

---

## Hotfix Workflow (Urgent Production Fix)

When a critical bug is found in production and can't wait for the normal flow:

```bash
# 1. Branch off main (not develop)
git switch main
git pull origin main
git switch -c hotfix/payment-crash

# 2. Fix the bug and commit
git add .
git commit -m "fix payment crash on checkout"

# 3. Merge back into BOTH main and develop
git switch main
git merge --no-ff hotfix/payment-crash
git push origin main

git switch develop
git merge --no-ff hotfix/payment-crash
git push origin develop

# 4. Tag the release on main
git tag -a v1.0.1 -m "hotfix: payment crash"
git push --tags

# 5. Delete hotfix branch
git branch -d hotfix/payment-crash
```

---

## Commit Message Convention

Good commit messages make history readable and useful.

**Format:**
```
<type>: <short description>

[optional body — what and why]
```

**Types:**

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, no logic change |
| `refactor` | Code restructure, no feature/fix |
| `test` | Adding or updating tests |
| `chore` | Build, config, dependencies |

**Examples:**
```
feat: add user login page
fix: resolve null pointer on checkout
docs: update README with setup steps
chore: upgrade node to v20
```

---

## Git Flow at a Glance

```
1. git switch develop && git pull
2. git switch -c feature/your-feature
3. [write code]
4. git add . && git commit -m "feat: ..."
5. git push -u origin feature/your-feature
6. Open Pull Request on GitHub → develop
7. Get reviewed → merge
8. git switch develop && git pull
9. git branch -d feature/your-feature
```

---

## Quick Reference

| Situation | Command |
|-----------|---------|
| Start new feature | `git switch -c feature/name` |
| Save work temporarily | `git stash` |
| Update branch with latest develop | `git rebase develop` |
| Undo last commit (keep changes) | `git reset --soft HEAD~1` |
| Undo a merged commit safely | `git revert <hash>` |
| Recover lost work | `git reflog` |
| Tag a release | `git tag -a v1.0.0 -m "release"` |

---

## Reference Files

| File | What It Covers |
|------|---------------|
| `git-basics.md` | init, clone, add, commit, push, pull |
| `git-branching.md` | branches, merge, conflicts |
| `git-advanced.md` | rebase, stash, cherry-pick, reset, revert |
| `git-remote.md` | remotes, fetch, upstream, SSH |
