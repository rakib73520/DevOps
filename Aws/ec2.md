# 🚀 AWS EC2 Instance — Setup & Connection Guide

> **Region used in this guide:** `eu-north-1` (Stockholm)

---

## Part 1: Launching an EC2 Instance

### Step 1 — Open EC2 Dashboard
1. Log in to [AWS Console](https://console.aws.amazon.com)
2. Make sure the region in the top-right corner is set to **eu-north-1 (Stockholm)**
3. Search for **EC2** in the search bar and open it
4. Click **"Launch Instance"**

---

### Step 2 — Name Your Instance
- Enter a descriptive name for your server (e.g., `my-web-server`)

---

### Step 3 — Choose an Amazon Machine Image (AMI)
An **AMI** is a pre-configured blueprint/template for your server (OS + software).

- If you have an existing AMI (custom template), select it — it will auto-fill the configuration
- Otherwise, select **Ubuntu** from the Quick Start list
  - Recommended: `Ubuntu Server 22.04 LTS (HVM), SSD Volume Type`

---

### Step 4 — Choose an Instance Type
The **instance type** defines the CPU and RAM of your server.

- Select **t3.micro** (eligible for AWS Free Tier in most accounts)

| Type | vCPU | RAM |
|------|------|-----|
| t3.micro | 2 | 1 GB |

---

### Step 5 — Configure Key Pair (SSH Login)
A **key pair** allows you to securely connect to your instance via SSH.

**If a key pair already exists:** select it from the dropdown.

**If creating a new key pair:**
1. Click **"Create new key pair"**
2. Enter a name (e.g., `my-ec2-key`)
3. Key pair type: **RSA**
4. Private key file format: **.pem** (for Linux/macOS/Windows with OpenSSH)
5. Click **"Create key pair"** — the `.pem` file will download automatically
6. ⚠️ **Save this file in a safe location** — you cannot download it again!

---

### Step 6 — Configure Network & Security Group
A **Security Group** acts as a virtual firewall, controlling who can send traffic to your instance.

**If an existing VPC/Security Group is available:**
- Select **"Select existing security group"** and choose it

**If creating a new Security Group:**
- Check the following inbound rules:

| Type  | Protocol | Port | Source     | Purpose                  |
|-------|----------|------|------------|--------------------------|
| SSH   | TCP      | 22   | My IP / 0.0.0.0/0 | Remote terminal access |
| HTTP  | TCP      | 80   | 0.0.0.0/0  | Web traffic (unencrypted) |
| HTTPS | TCP      | 443  | 0.0.0.0/0  | Web traffic (encrypted)  |

> 💡 For security, restrict SSH to **My IP** instead of `0.0.0.0/0` (anywhere)

---

### Step 7 — Configure Storage
This is the disk/hard drive of your server.

- AWS automatically provisions an **EBS (Elastic Block Store)** volume
- Default: **8 GB** (gp3 SSD) — increase if needed
- This volume will appear under **EC2 → Elastic Block Store → Volumes** in the console

> 💡 EBS is network-attached block storage — think of it as a virtual hard disk attached to your instance.

---

### Step 8 — Set Number of Instances
- Set the **number of instances** to launch (usually `1` for learning/dev)

---

### Step 9 — Launch
- Review the summary on the right panel
- Click **"Launch Instance"**
- AWS will take ~1–2 minutes to start your instance

---

## Part 2: Connecting to Your EC2 Instance

### Step 1 — Go to Your Instance
1. In the EC2 Dashboard, click **"Instances"** in the left sidebar
2. Select your newly created instance
3. Click **"Connect"** (top right)
4. Go to the **"SSH client"** tab — you'll find the exact connection command there

---

### Step 2 — Set Permissions on Your Key File
Before connecting, your `.pem` key file must be read-only. Run this in your terminal:

```bash
chmod 400 /path/to/your-key.pem
```

> ⚠️ AWS will reject your connection if the key file has open permissions. This is a required security step.

---

### Step 3 — Connect via SSH
Use the command shown in the "Connect" tab, or use this format:

```bash
ssh -i /path/to/your-key.pem ubuntu@<your-public-ip>
```

**Example:**
```bash
ssh -i ~/Downloads/my-ec2-key.pem ubuntu@13.48.12.34
```

> 💡 The default username for Ubuntu AMIs is `ubuntu`. For Amazon Linux it's `ec2-user`.

---

### Step 4 — Verify Connection
Once connected, you should see something like:

```
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 6.2.0-1012-aws x86_64)
ubuntu@ip-172-31-xx-xx:~$
```

You're now inside your EC2 instance! 🎉

---

## Quick Reference Cheatsheet

```bash
# Set key permissions (run once)
chmod 400 my-ec2-key.pem

# Connect to instance
ssh -i my-ec2-key.pem ubuntu@<PUBLIC_IP>

# Check current region (inside instance)
curl -s http://169.254.169.254/latest/meta-data/placement/region

# Update packages (first thing after login)
sudo apt update && sudo apt upgrade -y
```

---

## Key Concepts Summary

| Term | What It Is |
|------|-----------|
| **AMI** | Blueprint/template for creating an EC2 instance |
| **Instance Type** | Defines CPU + RAM (e.g., t3.micro = 2 vCPU, 1 GB RAM) |
| **Key Pair** | SSH credentials — `.pem` file to log in securely |
| **Security Group** | Firewall rules — controls inbound/outbound traffic |
| **EBS Volume** | Virtual hard disk (block storage) attached to your instance |
| **VPC** | Virtual Private Cloud — isolated network in AWS |
| **Public IP** | The IP address you use to connect to your instance |

---

*Guide based on AWS region: `eu-north-1` (Stockholm) | Ubuntu Server | t3.micro*
