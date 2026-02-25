# ⚖️ AWS Auto Scaling Group + Load Balancer

> Automatically scale EC2 instances up and down based on traffic, with a Load Balancer distributing requests across them.
> 📄 Requires a Launch Template — see `ec2-launch-templates.md` first.

---

## What is an Auto Scaling Group?

An **Auto Scaling Group (ASG)** automatically manages a fleet of EC2 instances:
- If traffic spikes → launches more instances
- If traffic drops → terminates excess instances
- If an instance crashes → replaces it automatically

A **Load Balancer** sits in front of all those instances and distributes incoming traffic evenly across them. You get one single URL that always works — regardless of how many instances are running behind it.

```
Users
  │
  ▼
Load Balancer (one URL)
  ├──▶ EC2 Instance 1
  ├──▶ EC2 Instance 2
  └──▶ EC2 Instance 3 (auto-added when traffic spikes)
```

---

## Part 1: Create a Load Balancer

**1.** EC2 Dashboard → left sidebar → **"Load Balancers"** → **"Create load balancer"**

**2.** Select type → **"Application Load Balancer"** → click **"Create"**

> Application Load Balancer (ALB) handles HTTP/HTTPS traffic — the right choice for web applications.

**3.** Basic configuration:
- **Name:** `my-app-alb`
- **Scheme:** `Internet-facing` *(accepts traffic from the internet)*
- **IP address type:** `IPv4`

**4.** Network mapping:
- **VPC:** select your VPC
- **Availability Zones:** select **at least 2** AZs and their public subnets
> 📄 See `vpc.md` — use the public subnets you created there.

**5.** Security groups:
- Select your existing security group (must allow HTTP port 80 and/or HTTPS port 443 inbound)
> 📄 See `security-group.md`

**6.** Listeners and routing:
- **Protocol:** `HTTP` | **Port:** `80`
- **Default action:** we need a Target Group — click **"Create target group"**

---

### Create Target Group (opens in new tab)

A **Target Group** is the group of EC2 instances the load balancer sends traffic to.

**1.** Target type → **"Instances"**

**2.** Fill in:
- **Target group name:** `my-app-tg`
- **Protocol:** `HTTP` | **Port:** `80`
- **VPC:** select your VPC

**3.** Health checks:
- **Protocol:** `HTTP`
- **Path:** `/` *(load balancer pings this path to check if the instance is healthy)*

**4.** Click **"Next"** → skip registering targets for now (ASG will handle this) → **"Create target group"** ✅

---

**7.** Back in the Load Balancer tab → refresh and select `my-app-tg` as the default action

**8.** Click **"Create load balancer"** ✅

---

## Part 2: Create the Auto Scaling Group

**1.** EC2 → left sidebar → **"Auto Scaling Groups"** → **"Create Auto Scaling group"**

---

### Step 1 — Name and Template
- **Auto Scaling group name:** `my-app-asg`
- **Launch template:** select `my-app-template`
- **Version:** `Latest` or pick `v1` / `v2`
- Click **"Next"**

---

### Step 2 — Instance Launch Options
- **VPC:** select your VPC
- **Availability Zones and subnets:** select **at least 2** public subnets
- Click **"Next"**

---

### Step 3 — Load Balancing
- Select **"Attach to an existing load balancer"**
- Choose **"Choose from your load balancer target groups"**
- Select `my-app-tg`
- **Health checks:** turn on **"ELB"** health checks
> This means if an instance fails the load balancer health check, ASG automatically replaces it.
- Click **"Next"**

---

### Step 4 — Group Size and Scaling
Set the instance count boundaries:

| Setting | Value | Meaning |
|---------|-------|---------|
| **Desired capacity** | `2` | Start with 2 instances running |
| **Minimum capacity** | `1` | Never go below 1 instance |
| **Maximum capacity** | `4` | Never exceed 4 instances |

**Scaling policies:**
- Select **"Target tracking scaling policy"**
- **Metric:** `Average CPU Utilization`
- **Target value:** `50` *(scale out when average CPU exceeds 50%)*

> When traffic spikes and CPU goes above 50% → ASG adds instances.
> When traffic drops and CPU falls below 50% → ASG removes instances.

- Click **"Next"**

---

### Step 5 — Notifications *(optional)*
- Skip for now or add an SNS topic to get email alerts when scaling events happen
- Click **"Next"**

---

### Step 6 — Tags *(optional)*
- Add a tag: Key `Name`, Value `my-app-instance`
> All instances launched by this ASG will have this tag — makes them easy to identify in EC2.
- Click **"Next"**

---

### Step 7 — Review and Create
- Review all settings
- Click **"Create Auto Scaling group"** ✅

AWS will immediately launch **2 instances** (desired capacity) using your launch template.

---

## Part 3: Get the Load Balancer URL

**1.** EC2 → **"Load Balancers"** → select `my-app-alb`

**2.** In the **"Details"** tab → find **"DNS name"**:
```
my-app-alb-1234567890.eu-north-1.elb.amazonaws.com
```

**3.** Open that URL in your browser

---

## What to Expect

After a minute or two (instances boot + health checks pass):

| What You See | What It Means |
|-------------|---------------|
| Your app / Nginx default page | ✅ Everything working — load balancer routing to a healthy instance |
| 502 Bad Gateway | Instance is still booting or User Data script hasn't finished yet — wait 1-2 minutes |
| Timeout / no response | Security group is missing HTTP port 80 inbound rule — check `security-group.md` |

**Verify instances are healthy:**
- EC2 → **"Target Groups"** → select `my-app-tg` → **"Targets"** tab
- All instances should show status **"healthy"**
- If **"unhealthy"** → the health check path `/` is returning an error on that instance

---

## Verify Auto Scaling Works

```
EC2 → Auto Scaling Groups → my-app-asg → "Activity" tab
```
Shows every scale-out and scale-in event — when instances were launched or terminated and why.

```
EC2 → Auto Scaling Groups → my-app-asg → "Instance management" tab
```
Shows all currently running instances managed by this ASG.

---

## Quick Reference

| Component | Purpose |
|-----------|---------|
| **Launch Template** | Blueprint for every instance the ASG creates |
| **Auto Scaling Group** | Manages how many instances run, scales up/down automatically |
| **Target Group** | The pool of instances the load balancer sends traffic to |
| **Application Load Balancer** | Single entry point — distributes traffic across the target group |
| **Health Check** | Load balancer pings `/` — unhealthy instances get replaced by ASG |
| **DNS Name** | Your single public URL — works no matter how many instances are behind it |

📄 References: `ec2-launch-templates.md` · `vpc.md` · `security-group.md`
