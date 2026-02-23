# 🔑 GitHub SSH Connection

> Connect your local machine to GitHub securely using SSH keys — no password needed on every push/pull.

---

## How It Works

```
Your Machine                        GitHub
┌─────────────────────┐             ┌──────────────────┐
│  Private Key 🔒     │ ←── auth ──▶│  Public Key 🔓   │
│  (~/.ssh/id_ed25519)│             │  (GitHub Settings)│
└─────────────────────┘             └──────────────────┘
```

- **Private key** — stays on your machine, never share this
- **Public key** — uploaded to GitHub, it's safe to share

---

## Steps

**1. Generate an SSH key pair**

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

It will ask:
```
Enter file in which to save the key: ↵ (press Enter for default)
Enter passphrase:                     ↵ (press Enter for no passphrase)
Enter same passphrase again:          ↵
```

> This creates two files in `~/.ssh/`:
> - `id_ed25519` — your **private key** (never share)
> - `id_ed25519.pub` — your **public key** (upload to GitHub)

---

**2. Copy your public key**

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the entire output — it looks like:
```
ssh-ed25519 AAAAC3Nza... you@example.com
```

---

**3. Add the public key to GitHub**

1. Go to [github.com](https://github.com) → click your profile picture → **Settings**
2. Left sidebar → **"SSH and GPG keys"**
3. Click **"New SSH key"**
4. Give it a title (e.g., `my-laptop` or `ubuntu-pc`)
5. Key type: **Authentication Key**
6. Paste your public key → click **"Add SSH key"**

---

**4. Test the connection**

```bash
ssh -T git@github.com
```

Expected output:
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

> ✅ You're connected! GitHub recognized your key.

---

**5. Use SSH URLs when cloning**

```bash
# ✅ SSH (no password prompts)
git clone git@github.com:username/repo.git

# ❌ HTTPS (asks for credentials every time)
git clone https://github.com/username/repo.git
```

**Switch an existing repo from HTTPS to SSH:**

```bash
git remote set-url origin git@github.com:username/repo.git

# Verify
git remote -v
```

---

## Multiple GitHub Accounts (optional)

If you have two GitHub accounts (e.g., personal + work), create separate keys and configure SSH to use the right one per host.

```bash
# Generate a second key with a different name
ssh-keygen -t ed25519 -C "work@company.com" -f ~/.ssh/id_ed25519_work
```

Edit `~/.ssh/config`:

```
# Personal
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

# Work
Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
```

Clone work repos using the alias:
```bash
git clone git@github-work:company/repo.git
```

---

## Quick Reference

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "you@example.com"

# View public key to copy
cat ~/.ssh/id_ed25519.pub

# Test GitHub connection
ssh -T git@github.com

# Switch repo from HTTPS to SSH
git remote set-url origin git@github.com:username/repo.git
```
