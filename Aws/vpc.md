# 🌐 AWS VPC Setup Guide

> Region: `eu-north-1` (Stockholm)

---

## What is a VPC?
Your own isolated private network inside AWS. You control the IP ranges, subnets, and who can access what.

| Component | What It Does |
|-----------|-------------|
| **Internet Gateway (IGW)** | Lets public subnets talk to the internet |
| **NAT Gateway** | Lets private subnets reach internet (outbound only) |
| **Public Subnet** | Accessible from the internet (web servers, load balancers) |
| **Private Subnet** | No direct internet access (databases, backend) |
| **Route Table** | Rules that control where traffic goes |

---

## Steps

**1. Search VPC** → open VPC Dashboard → **"Your VPCs"** → **"Create VPC"**

**2. Select "VPC and more"**
> This creates everything in one go: IGW, NAT, Subnets, Route Tables

**3. Give it a name** (e.g., `my-project`)
> AWS will auto-name all resources: `my-project-vpc`, `my-project-igw`, etc.

**4. Set IPv4 CIDR Block** (IP range)
> Default `10.0.0.0/16` = 65,536 IPs. Fine for most use cases.

**5. Number of Availability Zones**
> Learning → `1` | Production → `2 or 3`

**6. Number of Public Subnets**
> One per AZ selected. Used for internet-facing resources.

**7. Number of Private Subnets**
> One per AZ selected. Used for databases and internal services.

**8. NAT Gateway**
> - `None` → Free (private subnets can't reach internet — fine for learning)
> - `In 1 AZ` → ~$32/month (needed if private resources need to download packages etc.)

**9. Click "Create VPC"**

AWS automatically creates:
- ✅ VPC, Public & Private Subnets
- ✅ Internet Gateway (attached to VPC)
- ✅ NAT Gateway (if selected)
- ✅ Route Tables wired up correctly

---

## Using This VPC with EC2
When launching an EC2 instance → **Network Settings**:
- VPC → select your VPC
- Subnet → public (web server) or private (database)
