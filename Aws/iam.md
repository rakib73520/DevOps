# 👤 AWS IAM Setup Guide

> IAM (Identity and Access Management) is global — no region needed.

---

## What is IAM?
Controls **who can access** your AWS account and **what they can do**.

| Component | What It Is |
|-----------|------------|
| **User** | A person or app with their own login/credentials |
| **Group** | A collection of users that share the same permissions |
| **Role** | Temporary permissions assigned to AWS services (e.g., EC2 accessing S3) |
| **Policy** | A document that defines what is allowed or denied |

---

## Creating a User

**1. Search IAM** → left sidebar → **"Users"** → **"Create User"**

**2. Give it a name**
> e.g., `john-dev` or `deploy-bot`

**3. Set AWS Console access** *(optional)*
> Enable if this user needs to log in to the AWS Console.
> Set a password (auto-generated or custom).

**4. Set permissions — choose one:**
> - **Add user to a group** *(recommended)* → inherits group's policies
> - **Attach policies directly** → pick policies like `AmazonEC2FullAccess`, `AdministratorAccess`, etc.
> - **Copy permissions from another user**

**5. Review & click "Create User"**

> ⚠️ If console access is enabled, download or share the credentials — you can't retrieve the password again.

---

## Creating a Group

**1. Left sidebar → "User Groups"** → **"Create Group"**

**2. Give it a name** (e.g., `developers`, `devops-team`)

**3. Attach policies to the group**
> Search and select policies, e.g.:
> - `AmazonEC2FullAccess` — full EC2 control
> - `AmazonS3ReadOnlyAccess` — read-only S3
> - `AdministratorAccess` — full AWS access ⚠️ use carefully

**4. Add users to the group** *(optional at this step)*

**5. Click "Create Group"**

---

## Creating a Role *(for AWS services)*

A role lets an AWS service (like EC2) act on your behalf — e.g., allowing an EC2 instance to read from S3 without hardcoding credentials.

**1. Left sidebar → "Roles"** → **"Create Role"**

**2. Select trusted entity type → "AWS Service"**

**3. Choose the service** (e.g., `EC2`, `Lambda`)

**4. Attach a policy**
> e.g., `AmazonS3ReadOnlyAccess` if your EC2 needs to read from S3

**5. Give it a name** (e.g., `ec2-s3-read-role`) → **"Create Role"**

**6. Attach the role to your EC2 instance:**
> EC2 → Instances → select instance → **Actions → Security → Modify IAM Role**

---

## Key Tips

> 💡 **Never use the root account** for day-to-day work — create an admin IAM user instead.

> 💡 **Always follow least privilege** — give users/roles only the permissions they actually need.

> 💡 **Enable MFA** for all users, especially admins: IAM → Users → select user → **"Assign MFA device"**

> ⚠️ **Never hardcode credentials** (Access Key ID / Secret) in your code — use IAM Roles for services instead.
