# 🪣 AWS S3 Setup Guide

> S3 (Simple Storage Service) is global — but buckets are created in a specific region.

---

## What is S3?
S3 is AWS's object storage service. Store any file — images, videos, backups, static websites, logs — at any scale.

| Term | What It Is |
|------|------------|
| **Bucket** | A container for your files (like a top-level folder) |
| **Object** | Any file stored inside a bucket |
| **Key** | The full path/name of an object (e.g., `images/photo.png`) |
| **ACL** | Access Control List — who can read/write the bucket |
| **Bucket Policy** | JSON rules controlling public or cross-account access |

---

## Creating a Bucket

**1. Search S3** → **"Create Bucket"**

**2. Give it a name**
> e.g., `my-project-uploads`
> ⚠️ Bucket names are **globally unique** across all AWS accounts — if the name is taken, try another.

**3. Select a region**
> e.g., `eu-north-1` — pick the same region as your other resources to avoid transfer costs.

**4. Object Ownership**
> - `ACLs disabled` *(recommended)* — bucket owner owns everything
> - `ACLs enabled` — allow other accounts to own objects they upload

**5. Block Public Access**
> - Leave **all blocked** *(default)* for private buckets (backups, app storage)
> - Uncheck to allow public access if hosting a static website or public assets
> ⚠️ Only make public if you intentionally want the world to access your files.

**6. Versioning** *(optional)*
> Enable to keep a history of every file version — useful for backups and recovering deleted files.

**7. Encryption**
> Default: `SSE-S3` (AWS manages the keys) — fine for most use cases.

**8. Click "Create Bucket"**

---

## Uploading Files

**1. Click your bucket → "Upload"**

**2. Click "Add files" or drag and drop**

**3. Set permissions & storage class** *(optional — defaults are fine for most cases)*

**4. Click "Upload"**

---

## Storage Classes (Cost vs Access Speed)

| Class | Use Case | Cost |
|-------|----------|------|
| **S3 Standard** | Frequently accessed files | Higher |
| **S3 Standard-IA** | Infrequently accessed, needs fast retrieval | Lower |
| **S3 Glacier** | Long-term archival, retrieval takes minutes/hours | Cheapest |

> 💡 For learning and general use, stick with **S3 Standard**.

---

## Making a File Public

**Option A — Single file:**
> S3 → bucket → click file → **"Object actions" → "Make public"**
> *(Only works if bucket's public access is unblocked)*

**Option B — Bucket Policy (recommended for static sites):**
> S3 → bucket → **Permissions tab → Bucket Policy** → paste:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```
> Replace `your-bucket-name` with your actual bucket name.

---

## Hosting a Static Website *(optional)*

**1.** S3 → bucket → **Properties tab → "Static website hosting" → Enable**

**2.** Set index document: `index.html`

**3.** Unblock public access + add bucket policy above

**4.** Your site URL will be:
> `http://your-bucket-name.s3-website.eu-north-1.amazonaws.com`

---

## Key Tips

> 💡 **S3 is not a file system** — there are no real folders, just key names with `/` in them.

> 💡 Use **IAM roles** to give your EC2 instance access to S3 — never hardcode credentials.

> ⚠️ **Accidental public buckets** are a leading cause of AWS data breaches — double-check your public access settings.

> 💡 Enable **versioning** on important buckets so you can recover accidentally deleted files.
