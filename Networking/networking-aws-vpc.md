# ☁️ AWS Networking — VPC, Subnets & Gateways

> How AWS networking maps to real networking concepts — and how traffic actually flows in and out of your infrastructure.

---

## The Big Picture

When you create resources on AWS (like EC2 instances or databases), they don't just float in space — they live inside a **network** that you define and control. That network is called a **VPC**.

Everything you deploy in AWS exists within a VPC, and the VPC controls:
- Who can reach your resources
- Which resources can talk to each other
- What can and can't access the internet

```
                         Internet
                            │
                    Internet Gateway
                            │
              ┌─────────────────────────┐
              │          VPC            │
              │                         │
              │   ┌─────────────────┐   │
              │   │  Public Subnet  │   │ ← EC2 web servers, load balancers
              │   │   (frontend)    │   │
              │   └────────┬────────┘   │
              │            │            │
              │       NAT Gateway       │
              │            │            │
              │   ┌────────▼────────┐   │
              │   │  Private Subnet │   │ ← Databases, backend services
              │   │   (database)    │   │
              │   └─────────────────┘   │
              └─────────────────────────┘
```

---

## VPC — Virtual Private Cloud

A **VPC** is your own isolated, private network inside AWS. Think of it as renting a floor in a massive building (AWS) and setting up your own private office — you control the layout, who has keys, and what doors exist.

Without a VPC, all your AWS resources would be exposed and mingled with everyone else's. The VPC gives you isolation, control, and security.

**What you define in a VPC:**
- The IP address range (CIDR block) — how many addresses are available
- Subnets — how the address range is divided
- Routing rules — where traffic goes
- Access controls — who can talk to what

> Real-world: A VPC is like your company's private office building. You choose how many floors (subnets), which floors are public (reception, showroom) and which are private (HR, finance), and you control all the security.

📄 See `vpc.md` for setup steps.

---

## CIDR Block — Defining Your IP Range

When creating a VPC, you define a **CIDR block** — this sets how many IP addresses your network can have.

```
10.0.0.0/16  →  65,536 total IP addresses
10.0.0.0/24  →  256 total IP addresses
```

The number after `/` is called the **prefix length** — the larger it is, the fewer addresses you get.

> Real-world: Think of it like choosing how big your apartment complex is. `/16` is a huge complex with 65,000 apartments. `/24` is a small building with 256 units.

AWS reserves 5 IP addresses from every subnet (first 4 + last 1) for internal use, so your usable count is always slightly less.

---

## Subnets — Dividing Your Network

A **subnet** is a subdivision of your VPC. You split your VPC's IP range into smaller chunks, each serving a different purpose.

There are two types:

### Public Subnet
- Has a route to the **Internet Gateway**
- Resources here can be reached directly from the internet
- Use for: web servers, load balancers, bastion hosts, NAT Gateway

### Private Subnet
- Has **no** direct route to the internet
- Resources here are completely hidden from the outside world
- Use for: databases, internal APIs, backend services

> Real-world: Public subnet is the shop floor — customers can walk in. Private subnet is the back office — staff only, no public access.

---

## Internet Gateway (IGW)

An **Internet Gateway** is the bridge between your VPC and the public internet. Without it, nothing inside your VPC can communicate with the outside world at all.

When you attach an IGW to your VPC and add a route rule pointing `0.0.0.0/0` (all traffic) to it, your public subnet can:
- Receive incoming requests from users
- Send outgoing requests to the internet

> Real-world: The Internet Gateway is the front door of your office building. It's the only official entry/exit point between the public street (internet) and your building (VPC).

**Flow for a user visiting your website:**
```
User's browser
      │
      ▼
Internet Gateway  ← entry point into AWS
      │
      ▼
Public Subnet     ← your EC2 web server lives here
      │
      ▼
EC2 responds back through the same path
```

---

## NAT Gateway — One-Way Internet Access

A **NAT (Network Address Translation) Gateway** solves a specific problem: your private subnet resources (like a database server) sometimes need to reach the internet — to download software updates, call an external API, etc. — but you **never** want the internet to be able to reach them directly.

NAT Gateway sits in the **public subnet** and acts as a middleman:
- Private subnet sends a request outbound → NAT forwards it to the internet
- Internet sends a response back → NAT forwards it to the private subnet
- But nobody on the internet can initiate a connection into the private subnet

> Real-world: NAT Gateway is a one-way mirror. Staff in the back office (private subnet) can look out and make calls to the outside world. But people on the street can't see in or knock on the back door.

**Flow for a private EC2 downloading a software update:**
```
Private Subnet EC2
      │
      ▼
NAT Gateway (in public subnet)
      │
      ▼
Internet Gateway
      │
      ▼
Internet (package repository)
      │
Response flows back the same way ↑
```

---

## Route Tables — The Traffic Rules

Every subnet has a **route table** — a set of rules that tells traffic where to go based on its destination IP.

**Public Subnet Route Table:**
| Destination | Target | Meaning |
|-------------|--------|---------|
| `10.0.0.0/16` | local | Stay within the VPC |
| `0.0.0.0/0` | Internet Gateway | Everything else → go to the internet |

**Private Subnet Route Table:**
| Destination | Target | Meaning |
|-------------|--------|---------|
| `10.0.0.0/16` | local | Stay within the VPC |
| `0.0.0.0/0` | NAT Gateway | Outbound internet → go through NAT |

> Real-world: Route tables are like GPS rules. "If the destination is within the building (local), use the internal hallways. If the destination is outside (0.0.0.0/0), use the front door (IGW) or the staff exit (NAT)."

---

## Security Groups — Firewall at the Resource Level

A **Security Group** acts as a virtual firewall attached directly to individual resources (EC2 instances, RDS databases, etc.). It controls what traffic is allowed in and out at the resource level.

- **Inbound rules** — what traffic can reach this resource
- **Outbound rules** — what traffic can leave this resource (default: all allowed)

> Real-world: Security Groups are like a personal bodyguard for each resource. Even if someone gets into the building (through the IGW), the bodyguard still checks their ID before letting them into a specific room.

📄 See `security-group.md` for setup steps.

---

## Real-World Architecture Example

### A typical web application on AWS:

```
Users on the internet
         │
         ▼
  Internet Gateway
         │
         ▼
  ┌──────────────────────────────────┐
  │            Public Subnet          │
  │  ┌──────────┐   ┌─────────────┐  │
  │  │  Load    │   │  NAT        │  │
  │  │ Balancer │   │  Gateway    │  │
  │  └────┬─────┘   └──────┬──────┘  │
  └───────│────────────────│─────────┘
          │                │
  ┌───────│────────────────│─────────┐
  │       ▼   Private Subnet         │
  │  ┌──────────┐   ┌─────────────┐  │
  │  │  EC2     │   │  RDS        │  │
  │  │ (App     │──▶│ (Database)  │  │
  │  │ Server)  │   │             │  │
  │  └──────────┘   └─────────────┘  │
  └──────────────────────────────────┘
```

**How it works:**
1. A user visits your website → request hits the **Internet Gateway**
2. IGW routes it to the **Load Balancer** in the public subnet
3. Load Balancer forwards it to an **EC2 app server** in the private subnet
4. EC2 queries the **RDS database** (also in private subnet — internal traffic only)
5. Database responds → EC2 builds the response → sent back to the user
6. If EC2 needs to download a package update → goes through **NAT Gateway** → internet → back through NAT

The database is never directly reachable from the internet. Only the load balancer is public-facing.

---

## Key Concepts Summary

| Component | What It Does | Real-World Analogy |
|-----------|-------------|-------------------|
| **VPC** | Your isolated private network on AWS | Your company's private office building |
| **Public Subnet** | Accessible from the internet | Shop floor / reception area |
| **Private Subnet** | No direct internet access | Back office / server room |
| **Internet Gateway** | Entry/exit to the public internet | The building's front door |
| **NAT Gateway** | Outbound-only internet for private subnets | One-way mirror / staff exit |
| **Route Table** | Traffic rules — where does each packet go | GPS directions for your network |
| **Security Group** | Firewall per resource | Personal bodyguard for each server |
| **CIDR Block** | The IP address range of your network | How many apartments in your building |

📄 See `vpc.md` for step-by-step VPC creation.
📄 See `security-group.md` for security group setup.
📄 See `networking-fundamentals.md` for core networking concepts.
