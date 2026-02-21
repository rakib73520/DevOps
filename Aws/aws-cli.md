# ⌨️ AWS CLI Setup Guide

> Connect your terminal (local PC or EC2 instance) to AWS so you can manage resources via command line.

---

## What is AWS CLI?
A tool that lets you control AWS services directly from your terminal instead of clicking through the console.

```bash
# Examples of what you can do
aws s3 ls                          # list all S3 buckets
aws s3 cp file.txt s3://my-bucket  # upload a file to S3
aws ec2 describe-instances         # list EC2 instances
```

---

## Part 1: Install AWS CLI

**On Ubuntu (EC2 or local):**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**Verify installation:**
```bash
aws --version
# aws-cli/2.x.x Python/3.x.x Linux/...
```

---

## Part 2: Create Access Keys (from IAM)

Access keys are how the CLI proves it's allowed to talk to your AWS account.

**1. Search IAM** → **"Users"** → click your user

**2. Go to "Security credentials" tab**

**3. Scroll to "Access keys"** → **"Create access key"**

**4. Use case → select "CLI"** → confirm → **"Create access key"**

**5. Download the `.csv` file or copy both keys:**
> - `Access Key ID` (like a username)
> - `Secret Access Key` (like a password)

> ⚠️ You can only see the Secret Access Key **once** — save it immediately.

---

## Part 3: Configure AWS CLI

Run this in your terminal (local or EC2):

```bash
aws configure
```

It will ask 4 things:

```
AWS Access Key ID:     paste your Access Key ID
AWS Secret Access Key: paste your Secret Access Key
Default region name:   eu-north-1
Default output format: json
```

> 💡 Credentials are saved to `~/.aws/credentials` on your machine.

**Verify it works:**
```bash
aws sts get-caller-identity
```
> This returns your account ID and user — confirms the CLI is connected.

---

## Part 4: Connect EC2 to S3 (the right way — using IAM Role)

> ⚠️ If you're on an **EC2 instance**, do NOT use `aws configure` with access keys.
> Instead, attach an **IAM Role** to your EC2 — it's more secure and AWS handles credentials automatically.

**1.** Create an IAM Role with the right policy (e.g., `AmazonS3FullAccess`)
> See `iam.md` → Creating a Role

**2.** Attach the role to your EC2 instance:
> EC2 → Instances → select instance → **Actions → Security → Modify IAM Role** → select role → **Update**

**3.** Now on your EC2 instance, the CLI just works — no `aws configure` needed:
```bash
aws s3 ls                          # list buckets
aws s3 cp file.txt s3://my-bucket  # upload file
aws s3 sync ./folder s3://my-bucket # sync entire folder
```

---

## Common S3 CLI Commands

```bash
aws s3 ls                              # list all buckets
aws s3 ls s3://my-bucket               # list contents of a bucket
aws s3 cp file.txt s3://my-bucket/     # upload a file
aws s3 cp s3://my-bucket/file.txt .    # download a file
aws s3 sync ./dist s3://my-bucket/     # sync local folder to bucket
aws s3 rm s3://my-bucket/file.txt      # delete a file
```

---

## Summary: Local vs EC2

| | Local PC | EC2 Instance |
|--|----------|--------------|
| **Auth method** | `aws configure` with access keys | IAM Role attached to instance |
| **Credentials stored** | `~/.aws/credentials` | Managed by AWS automatically |
| **More secure?** | Less (keys can leak) | ✅ Yes (no keys to manage) |
