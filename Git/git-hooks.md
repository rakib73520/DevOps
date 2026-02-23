# 🪝 Git Hooks

> Scripts that run automatically at specific points in your Git workflow — before commits, before pushes, after merges, etc.

---

## What are Git Hooks?

Hooks are shell scripts that Git runs for you automatically. They live inside your repo at:

```
your-project/
└── .git/
    └── hooks/
        ├── pre-commit        ← runs before every commit
        ├── commit-msg        ← runs to validate commit message
        ├── pre-push          ← runs before every push
        ├── post-merge        ← runs after a merge
        └── ... (many more)
```

> 💡 `.git/hooks/` already contains sample files with `.sample` extension — rename them to activate.

---

## Types of Hooks

### Client-Side Hooks (run on your machine)

| Hook | When It Runs | Common Use |
|------|-------------|------------|
| `pre-commit` | Before commit is created | Run linter, tests, check for secrets |
| `commit-msg` | After you write the commit message | Enforce commit message format |
| `pre-push` | Before pushing to remote | Run full test suite |
| `post-merge` | After a merge completes | Auto-install dependencies |
| `post-checkout` | After switching branches | Environment setup |

### Server-Side Hooks (run on GitHub/GitLab server)

| Hook | When It Runs | Common Use |
|------|-------------|------------|
| `pre-receive` | Before accepting a push | Enforce branch rules |
| `post-receive` | After push is accepted | Trigger deployments |

> ℹ️ Server-side hooks are managed by your Git server admin — not something you set up locally.

---

## Creating a Hook

### Example 1 — `pre-commit`: Run linter before every commit

```bash
# Navigate to hooks folder
cd .git/hooks

# Create the pre-commit hook
touch pre-commit
chmod +x pre-commit   # make it executable
```

Edit `pre-commit`:

```bash
#!/bin/sh

echo "Running linter..."
npm run lint

# If linter fails (exit code not 0), abort the commit
if [ $? -ne 0 ]; then
  echo "❌ Lint failed. Fix errors before committing."
  exit 1
fi

echo "✅ Lint passed."
```

> Now every time you run `git commit`, the linter runs first. If it fails, the commit is blocked.

---

### Example 2 — `commit-msg`: Enforce commit message format

```bash
touch .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

Edit `commit-msg`:

```bash
#!/bin/sh

COMMIT_MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|style|refactor|test|chore): .+"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
  echo "❌ Invalid commit message: '$COMMIT_MSG'"
  echo "Format must be: <type>: <description>"
  echo "Example: feat: add login page"
  exit 1
fi
```

> Blocks commits that don't follow the `feat: description` convention.
> See `git-workflow.md` for commit message types.

---

### Example 3 — `pre-push`: Run tests before pushing

```bash
touch .git/hooks/pre-push
chmod +x .git/hooks/pre-push
```

Edit `pre-push`:

```bash
#!/bin/sh

echo "Running tests before push..."
npm test

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Push aborted."
  exit 1
fi

echo "✅ All tests passed. Pushing..."
```

---

### Example 4 — `post-merge`: Auto-install dependencies after pull/merge

```bash
touch .git/hooks/post-merge
chmod +x .git/hooks/post-merge
```

Edit `post-merge`:

```bash
#!/bin/sh

# Check if package.json changed in the merge
if git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep -q "package.json"; then
  echo "📦 package.json changed — running npm install..."
  npm install
fi
```

> Automatically runs `npm install` if dependencies changed after a pull or merge.

---

## Sharing Hooks with Your Team

The problem: `.git/hooks/` is not tracked by Git — so hooks don't get shared when teammates clone the repo.

### Solution A — Store hooks in the repo and configure Git to use them

```bash
# Create a folder in your repo (this IS tracked by Git)
mkdir .githooks

# Move your hooks there
cp .git/hooks/pre-commit .githooks/pre-commit

# Tell Git to use this folder for hooks
git config core.hooksPath .githooks
```

Add to your README:
```bash
# teammates run this after cloning
git config core.hooksPath .githooks
```

---

### Solution B — Use Husky (Node.js projects)

[Husky](https://typicode.github.io/husky) is the most popular tool for managing Git hooks in JS projects — hooks are stored in the repo and automatically shared.

```bash
# Install husky
npm install --save-dev husky

# Initialize
npx husky init

# This creates a .husky/ folder with a pre-commit hook
# Edit .husky/pre-commit:
npm run lint
```

> 💡 Husky integrates with `package.json` scripts and is the standard approach for Node/JavaScript teams.

---

## Skipping Hooks (When Needed)

```bash
# Skip pre-commit and commit-msg hooks
git commit --no-verify -m "emergency fix"

# Skip pre-push hook
git push --no-verify
```

> ⚠️ Use `--no-verify` sparingly — it defeats the purpose of the hook.

---

## Quick Reference

| Hook | Trigger | Typical Use |
|------|---------|-------------|
| `pre-commit` | `git commit` | Lint, format check |
| `commit-msg` | `git commit` | Validate message format |
| `pre-push` | `git push` | Run tests |
| `post-merge` | `git merge` / `git pull` | Install dependencies |
| `post-checkout` | `git switch` | Environment setup |

```bash
# Make a hook executable
chmod +x .git/hooks/pre-commit

# Share hooks with team via config
git config core.hooksPath .githooks

# Skip hooks when needed
git commit --no-verify -m "message"
```
