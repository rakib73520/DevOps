# 🔒 AWS Security Group Setup Guide

> Region: `eu-north-1` (Stockholm)

---

## What is a Security Group?
A virtual firewall that controls **who can send traffic to** and **from** your AWS resources (EC2, RDS, etc.).

| Rule Type | Direction | Example |
|-----------|-----------|---------|
| **Inbound** | Traffic coming IN to your instance | Allow SSH from your IP |
| **Outbound** | Traffic going OUT from your instance | Allow all outbound (default) |

---

## Steps

**1. Search EC2** → left sidebar → **"Security Groups"** → **"Create Security Group"**

**2. Give it a name & description**
> e.g., name: `my-project-sg`, description: `Security group for web server`

**3. Select your VPC**
> Choose the VPC you created (e.g., `my-project-vpc`)
> ⚠️ A security group only works within the VPC it's created in.

**4. Add Inbound Rules**
> Click **"Add rule"** for each one you need:

| Type  | Protocol | Port | Source | Use |
|-------|----------|------|--------|-----|
| SSH | TCP | 22 | My IP | Remote terminal access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web traffic |

> 💡 **Source options:**
> - `My IP` → only your current IP can access (safest for SSH)
> - `0.0.0.0/0` → anyone on the internet can access
> - `Custom` → specific IP or another security group

**5. Outbound Rules**
> Leave as default — allows all outbound traffic.
> Only restrict if you have a specific security requirement.

**6. Add Tags** *(optional)*
> e.g., Key: `Name`, Value: `my-project-sg`

**7. Click "Create Security Group"**

---

## Using This Security Group with EC2
When launching an EC2 instance → **Network Settings**:
- Select **"Select existing security group"**
- Choose the one you just created

> 💡 You can attach/change a security group on a running instance too:
> EC2 → Instances → select instance → **Actions → Security → Change Security Groups**
