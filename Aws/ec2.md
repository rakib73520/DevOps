# 🚀 AWS EC2 Instance Setup Guide (Ubuntu -- t3.micro)

This document provides a complete step-by-step guide to launching and
connecting to an AWS EC2 instance.

------------------------------------------------------------------------

## 🌍 1. Select Region

Before creating your instance, make sure the correct region is selected
from the top-right corner of the AWS Console.

Example used in this guide:

    eu-north-1

------------------------------------------------------------------------

# 🖥 2. Launch EC2 Instance

## Step 1: Open EC2 Dashboard

-   Login to AWS Console
-   Search for **EC2**
-   Click **Launch Instance**

------------------------------------------------------------------------

## Step 2: Name the Instance

Give a meaningful name:

    devops-ubuntu-server

------------------------------------------------------------------------

## Step 3: Choose Amazon Machine Image (AMI)

An **AMI (Amazon Machine Image)** is a template used to create your
server.

Select:

    Ubuntu Server (Latest LTS)

------------------------------------------------------------------------

## Step 4: Choose Instance Type

Select:

    t3.micro

Specifications: - 1 vCPU - 1 GB RAM - Free-tier eligible (in most cases)

------------------------------------------------------------------------

## Step 5: Configure Key Pair

If a key pair already exists: - Select the existing key pair

Otherwise: - Click **Create new key pair** - Name: `devops-key` - Type:
`RSA` - Format: `.pem` - Download and store securely

⚠️ The key file cannot be downloaded again.

------------------------------------------------------------------------

## 🌐 6. Configure Network Settings

### VPC

-   Select an existing VPC\
    OR\
-   Use the default VPC (recommended for beginners)

------------------------------------------------------------------------

### Security Group (Firewall Rules)

You can select an existing security group or create a new one.

If creating a new one, add inbound rules:

  Type    Port   Purpose
  ------- ------ --------------------
  SSH     22     Remote access
  HTTP    80     Web traffic
  HTTPS   443    Secure web traffic

For learning purposes:

    Source: 0.0.0.0/0

⚠️ In production, restrict SSH access to your IP only.

------------------------------------------------------------------------

## 💾 7. Configure Storage

Storage is managed by **EBS (Elastic Block Store)**.

Important clarification: - RAM is defined by instance type. - Storage is
handled separately via EBS.

Default:

    8 GB gp3 (SSD)

After launching: - Go to EC2 → Volumes - You will see the attached EBS
volume

------------------------------------------------------------------------

## 🔢 8. Number of Instances

Set:

    1

------------------------------------------------------------------------

## 🚀 9. Launch Instance

Click:

    Launch Instance

Wait until:

    Instance State = Running

------------------------------------------------------------------------

# 🔐 10. Connect to EC2 from Local Machine

## Step 1: Go to EC2 → Instances

-   Select your instance
-   Click **Connect**
-   Choose **SSH client**

------------------------------------------------------------------------

## Step 2: Set Permission for Key File

Navigate to the folder where the `.pem` file is downloaded.

Run:

``` bash
chmod 400 devops-key.pem
```

------------------------------------------------------------------------

## Step 3: Connect via SSH

Example command:

``` bash
ssh -i devops-key.pem ubuntu@your-public-ip
```

For Ubuntu:

    Username: ubuntu

For Amazon Linux:

    Username: ec2-user

------------------------------------------------------------------------

# ✅ Verify Connection

If successful, you will see:

``` bash
ubuntu@ip-xxx-xxx-xxx-xxx:~$
```

Your EC2 instance is now connected successfully.

------------------------------------------------------------------------

# ❗ Common Mistakes

-   Wrong region selected
-   Port 22 (SSH) not open
-   Wrong username
-   Forgot to run `chmod 400`
-   Using incorrect key pair
-   Instance not in "Running" state

------------------------------------------------------------------------

# 📌 Summary

In this setup, we:

-   Selected region (`eu-north-1`)
-   Chose Ubuntu AMI
-   Selected instance type (`t3.micro`)
-   Created/selected key pair
-   Configured security group
-   Configured EBS storage
-   Launched instance
-   Connected using SSH

------------------------------------------------------------------------

You can extend this documentation later by adding:

-   Nginx installation
-   Node.js deployment
-   Docker setup
-   IAM role attachment
-   Elastic IP configuration

Keep building step by step 🚀
