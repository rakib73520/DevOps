# 🐳 Docker — Theory & Concepts

> The evolution of how we run software, and why containers exist.

---

## The Evolution — From Servers to Containers

### Era 1: Physical Servers (Before 2000s)

In the early days, every application ran on its own dedicated physical server. If a company had 5 applications, they needed 5 physical machines.

**Problems:**
- **Underutilization** — a server running one small app might only use 10% of its CPU and RAM. The rest is wasted.
- **Dependency conflicts** — if App A needs Python 2 and App B needs Python 3, they can't coexist on the same machine.
- **Not scalable** — need more capacity? Buy another physical server, wait for delivery, rack it, configure it. Takes days or weeks.
- **Expensive** — hardware, electricity, cooling, physical space.

---

### Era 2: Virtual Machines (2000s)

**Virtual Machines (VMs)** solved the physical server problem by running multiple "computers inside a computer."

A piece of software called a **Hypervisor** sits between the hardware and the operating systems. It divides the physical hardware (CPU, RAM, storage) into isolated virtual machines, each with its own full operating system.

```
Physical Server
├── Hardware (CPU, RAM, Storage)
├── Hypervisor
│   ├── VM 1 (Full OS + App A)
│   ├── VM 2 (Full OS + App B)
│   └── VM 3 (Full OS + App C)
```

**Popular Hypervisors:**
- VMware ESXi
- Microsoft Hyper-V
- KVM, Xen
- AWS EC2 uses the **Nitro Hypervisor** under the hood

**Problems with VMs:**
- Each VM needs its own full OS — heavy on resources (GBs of RAM just for the OS)
- Slow to start (booting a full OS takes minutes)
- Even with VMs, running multiple apps on one VM caused conflicts and inefficiency — so teams still ended up running one app per VM

---

### Era 3: Containers (2010s — Present)

**Containers** solved what VMs couldn't. Instead of virtualizing the entire hardware and running a full OS for each app, containers share the **host OS kernel** and only package the app itself along with its dependencies (libraries, configs, runtime).

```
Physical Server
├── Hardware
├── Host Operating System
├── Container Runtime (Docker)
│   ├── Container 1 (App A + its dependencies)
│   ├── Container 2 (App B + its dependencies)
│   └── Container 3 (App C + its dependencies)
```

**Advantages over VMs:**

| | Virtual Machine | Container |
|--|----------------|-----------|
| **Size** | GBs (full OS) | MBs (just the app + libs) |
| **Startup time** | Minutes | Seconds |
| **Isolation** | Full hardware isolation | Process-level isolation |
| **Portability** | Less portable | Runs anywhere Docker runs |
| **Density** | Few per server | Many per server |

> Real-world: A VM is like renting an entire apartment — you get your own kitchen, bathroom, living room even if you just need a bed. A container is like renting just a room in a shared house — you share the infrastructure (kitchen, bathroom) but have your own private space.

---

## What is Docker?

**Docker** is the most popular tool for building, running, and managing containers. It provides everything you need to package an application and its dependencies into a container and run it anywhere.

> Think of Docker like a cargo ship. The ship (Docker) carries multiple shipping containers — one might hold Pathao's app, another Amazon's, another bKash's. Each container is completely isolated — one doesn't affect the others.

Docker runs on any operating system (Linux, macOS, Windows) and has a huge ecosystem of pre-built images on **DockerHub**.

---

## What is Kubernetes?

As you scale up — running dozens or hundreds of containers across multiple servers — managing them manually becomes impossible. That's where **Kubernetes** comes in.

**Kubernetes** is a container orchestration tool. It automatically:
- **Deploys** containers across multiple servers
- **Restarts** crashed containers automatically
- **Scales** containers up or down based on traffic
- **Load balances** traffic across containers
- **Updates** containers with zero downtime
- **Monitors** the health of every container

> Real-world: If Docker is the cargo ship carrying containers, Kubernetes is the entire shipping company's logistics system — tracking every container, rerouting when something goes wrong, adding more ships when demand spikes.

> When a Docker container crashes, Kubernetes detects it and automatically restarts it. This is called **container orchestration**.

---

## The Modern Container Ecosystem

```
Your App Code
      │
      ▼
  Dockerfile  ← instructions to build the image
      │
      ▼
  Docker Image  ← snapshot/blueprint (stored on DockerHub)
      │
      ▼
  Container  ← running instance of the image
      │
      ▼
  Kubernetes  ← manages, scales, restarts containers across servers
```

**Container Runtime:** To actually run containers, a runtime is needed. Docker originally used **containerd** as its runtime. Today, Kubernetes also uses containerd directly — meaning even without Docker, Kubernetes can manage containers.

---

## Docker's Core Components

### Dockerfile
A plain text script with instructions on how to build a Docker image. It defines the base OS, what software to install, what files to copy, and what command to run when the container starts.

> Real-world: A Dockerfile is like a recipe. It says "start with Ubuntu, install Node.js, copy my app files, run npm start." Anyone with that recipe can bake the exact same cake.

---

### Image
A **snapshot or blueprint** of a container — built from a Dockerfile. Images are read-only. You can store and share them on DockerHub.

> Real-world: An image is like a cookie cutter. You use it to create as many identical cookies (containers) as you want. The cutter itself never changes.

---

### Container
A **running instance of an image**. This is the actual live application. You can run multiple containers from the same image simultaneously.

> Real-world: If the image is the cookie cutter, the container is the actual cookie — a real, running thing that can be started, stopped, or deleted.

---

### Volume
**Persistent storage** for containers. Containers are ephemeral — when a container crashes or is removed, all data inside it is lost. Volumes solve this by storing data outside the container.

> Real-world: Imagine your database lives in a container. The container crashes — without a volume, all your data is gone forever. With a volume, the data lives separately on the host machine. When you restart the container, it reconnects to the volume and all data is intact.

**Common use case:** MySQL/PostgreSQL database containers always use volumes so data survives container restarts.

---

### Network
Controls how containers communicate with each other and with the outside world. By default, containers are isolated — they can't talk to each other unless connected through a Docker network.

> Real-world: If your backend container needs to talk to your database container, they need to be on the same Docker network — like being on the same internal phone system.

---

### DockerHub
A public registry where Docker images are stored and shared. Think of it like GitHub, but for Docker images instead of code.

- Pull official images (Ubuntu, MySQL, Node.js, Nginx) directly from DockerHub
- Push your own custom images to share with your team
- Private registries also available for proprietary images

> `docker pull mysql:latest` downloads the official MySQL image from DockerHub.
