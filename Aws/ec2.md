🚀 AWS EC2 Setup Guide (Step-by-Step)
📍 Region

Make sure your region is selected correctly (example used here):

eu-north-1

Always confirm the region from the top-right corner of the AWS Console.

1️⃣ Launch an EC2 Instance
Step 1: Open EC2 Dashboards

Go to AWS Console

Search EC2

Click Launch Instance

Step 2: Name Your Instance

Give a meaningful name, for example:

devops-ubuntu-server
Step 3: Choose Amazon Machine Image (AMI)

An Amazon Machine Image (AMI) is a blueprint/template used to create your server.

Select:

Ubuntu Server (Latest LTS)

If you already have a custom AMI, you can select it.

Step 4: Choose Instance Type

Select:

t3.micro

1 vCPU

1 GB RAM

Eligible for Free Tier (in many cases)

Step 5: Key Pair (Very Important)

If you already have a key pair:

Select existing key pair

Otherwise:

Click Create new key pair

Name: devops-key

Type: RSA

Format: .pem

Download the key file

Save it securely on your local machine

⚠️ You cannot download this key again later.

Step 6: Network Settings (VPC & Security Group)
VPC

If you already have a VPC:

Select existing VPC

Otherwise:

Use default VPC (recommended for beginners)

Security Group (Firewall Rules)

You can:

Select existing security group
OR

Create a new one

If creating new:

Add Inbound Rules

Inbound rules define who can access your server.

Typical rules:

Type	Port	Purpose
SSH	22	Connect from local machine
HTTP	80	Allow web traffic
HTTPS	443	Secure web traffic

For learning purposes, you may allow:

Source: Anywhere (0.0.0.0/0)

⚠️ In production, never open SSH to the whole world.

Step 7: Configure Storage

Here you configure EBS (Elastic Block Storage).

Important clarification:

RAM is defined by instance type (t3.micro → 1GB RAM)

Storage is EBS volume (hard disk of your server)

Default:

8 GB gp3 (General Purpose SSD)

You can increase storage if needed.

After launching:

Go to EC2 → Volumes

You will see the attached EBS volume

Step 8: Number of Instances

Set:

1 instance

(You can launch multiple if needed)

Step 9: Launch Instance

Click:

Launch Instance

Wait until:

Instance State = Running
2️⃣ Connect to EC2 from Local Machine
Step 1: Go to EC2 → Instances

Select your instance

Click Connect

Step 2: Give Permission to Key File (Important)

Go to the folder where your .pem file is downloaded.

Run:

chmod 400 devops-key.pem

This gives read-only permission to the key.

Step 3: Connect Using SSH

Copy the command provided by AWS.

Example:

ssh -i devops-key.pem ubuntu@your-public-ip

For Ubuntu:

username = ubuntu

For Amazon Linux:

username = ec2-user
✅ Verify Connection

After successful connection, you should see something like:

ubuntu@ip-xxx-xxx-xxx-xxx:~$

Now your EC2 server is successfully connected 🎉