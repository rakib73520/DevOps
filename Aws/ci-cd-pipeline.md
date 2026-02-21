# 🚀 CI/CD Pipeline — EC2 + S3 + GitHub Actions

> Every push to your GitHub repo automatically deploys your project to S3, accessible via EC2.

---

## Overview

```
Local Code → GitHub Push → GitHub Actions (CI/CD) → S3 Bucket → EC2 serves the app
```

**What we'll set up:**
1. EC2 instance (your server)
2. S3 bucket (your file/project storage)
3. IAM user with access to both
4. Connect EC2 to S3 via AWS CLI
5. Upload project to S3
6. GitHub Actions workflow to auto-deploy on every push

---

## Part 1: Create the Infrastructure

### 1.1 — Create an EC2 Instance

> 📄 Follow `ec2.md` for full steps.

---

### 1.2 — Create an S3 Bucket

> 📄 Follow `s3.md` for full steps.

---

### 1.3 — Create an IAM User with EC2 + S3 Access

> 📄 Follow `iam.md` for full steps.

---

## Part 2: Connect EC2 to Your Local Terminal

> 📄 Follow `ec2.md → Part 2` for full steps.


You're now inside your EC2 machine.

---

## Part 3: Install AWS CLI & Connect EC2 to S3

> 📄 Follow `aws-cli.md` for full steps.


EC2 and S3 are now connected. ✅

---

## Part 4: Set Up GitHub Actions (CI/CD Workflow)

### 4.1 — Create the Workflow File

In your project repo, create this file:

```
your-project/
└── .github/
    └── workflows/
        └── main.yaml
```

Paste this into `main.yaml`:

```yaml
name: Deploy to S3

on:
  push:
    branches:
      - main   # triggers on every push to main branch

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-north-1   # ← your S3 bucket region

      - name: Sync to S3
        run: |
          aws s3 sync . s3://my-project-bucket --delete
```

> 💡 `--delete` removes files from S3 that no longer exist in your repo.
> Replace `my-project-bucket` with your actual bucket name.

---

### 4.2 — Add Secret Keys to GitHub

The `main.yaml` uses `${{ secrets.AWS_ACCESS_KEY_ID }}` — these are stored securely in GitHub, never in your code.

**1.** Go to your GitHub repository → **Settings**

**2.** Left sidebar → **Secrets and variables → Actions**

**3.** Click **"New repository secret"** — add these two:

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | Your IAM user's Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | Your IAM user's Secret Access Key |

> ⚠️ The secret names must **exactly match** what's written in `main.yaml`.

---

## Part 5: Test the Pipeline

```bash
# On your local machine, make a change and push
git add .
git commit -m "test ci/cd pipeline"
git push origin main
```

**Then check:**
- GitHub → your repo → **Actions tab** → watch the workflow run
- If green ✅ → your files are now live in S3
- Verify in AWS Console → S3 → your bucket → files should be updated

---

## Full Flow Summary

```
You push code to GitHub (main branch)
        ↓
GitHub Actions triggers main.yaml
        ↓
GitHub uses your IAM credentials (stored as secrets)
        ↓
Runs: aws s3 sync → uploads project files to S3 bucket
        ↓
EC2 serves the app from S3 (or pulls from S3 as needed)
```

---

## Reference Files

| File | What It Covers |
|------|---------------|
| `ec2.md` | Creating and connecting to EC2 |
| `s3.md` | Creating S3 bucket and policies |
| `iam.md` | Creating users, roles, access keys |
| `aws-cli.md` | Installing CLI and `aws configure` |
| `vpc.md` | Network setup for EC2 |
| `security-group.md` | Firewall rules for EC2 |
