# 🐳 Docker — Hands-On Guide

> Step-by-step setup and essential commands to work with Docker.

---

## Part 1: Installation & Setup

### Install Docker

```bash
sudo apt update
sudo apt install docker.io -y        # -y automatically answers yes to all prompts
```

### Add Your User to the Docker Group

By default, only root can run Docker commands. Add your user to the docker group so you don't need `sudo` every time.

```bash
sudo usermod -aG docker $USER        # -a = append, -G = group, $USER = current user
```

Verify the docker group and its members:
```bash
sudo cat /etc/group | grep docker    # shows docker group and users in it
```

### Reboot to Apply Group Changes

```bash
sudo reboot
```

> After reboot, reconnect to your server and verify Docker works without sudo:

```bash
docker ps                            # should work without sudo now
```

### Verify Installation

```bash
docker --version
docker ps -a                         # list all containers (running and stopped)
```

---

## Part 2: Working with Images

Images are the blueprints. You pull them from DockerHub and use them to create containers.

```bash
# Pull an image from DockerHub (download without running)
docker pull hello-world
docker pull mysql:latest
docker pull ubuntu:22.04

# List all images on your machine
docker images

# Remove an image
docker rmi <image_id>

# Remove all unused images
docker image prune
```

---

## Part 3: Running Containers

```bash
# Create and run a container from an image
# (if image isn't pulled yet, Docker pulls it automatically)
docker run hello-world

# Run in detached mode (background) — you keep your terminal
docker run -d mysql:latest

# Run with environment variables
docker run -d -e MYSQL_ROOT_PASSWORD=1234 mysql:latest

# Run with a name so it's easier to reference
docker run -d --name my-mysql -e MYSQL_ROOT_PASSWORD=1234 mysql:latest

# Run and map a port (host_port:container_port)
docker run -d -p 8080:80 nginx:latest
# Now visit http://localhost:8080 to see Nginx
```

> 💡 `-d` = detached (runs in background)
> `-e` = environment variable
> `-p` = port mapping
> `--name` = give the container a name

---

## Part 4: Managing Containers

```bash
# List running containers
docker ps

# List ALL containers (running + stopped)
docker ps -a

# Start a stopped container
docker start <container_id>

# Stop a running container
docker stop <container_id>

# Restart a container
docker restart <container_id>

# Remove a stopped container
docker rm <container_id>

# Force remove a running container
docker rm -f <container_id>

# Remove all stopped containers
docker container prune
```

---

## Part 5: Entering a Container

Sometimes you need to get inside a running container to debug, run commands, or inspect files.

```bash
# Enter a container's bash shell
docker exec -it <container_id> bash

# -it = interactive terminal
# bash = open the bash shell inside the container
```

**Example — enter a MySQL container and check databases:**

```bash
# First, run a MySQL container
docker run -d --name my-mysql -e MYSQL_ROOT_PASSWORD=1234 mysql:latest

# Enter the container
docker exec -it my-mysql bash

# Inside the container — log into MySQL
mysql -u root -p
# enter password: 1234

# Inside MySQL — show all databases
show databases;

# Exit MySQL
exit

# Exit the container
exit
```

---

## Part 6: Volumes — Persistent Storage

Without a volume, all data inside a container is lost when the container stops or crashes.

```bash
# Create a named volume
docker volume create my-data

# List volumes
docker volume ls

# Run a container with a volume attached
docker run -d \
  --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -v my-data:/var/lib/mysql \
  mysql:latest

# my-data = volume name
# /var/lib/mysql = where MySQL stores its data inside the container
```

Now if the container crashes:
```bash
docker rm -f my-mysql                # remove crashed container

# Restart with same volume — data is preserved
docker run -d \
  --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -v my-data:/var/lib/mysql \
  mysql:latest
```

> ✅ All your database data is intact because it was stored in the volume, not inside the container.

---

## Part 7: Writing a Dockerfile

A Dockerfile is a script that defines how to build your own custom image.

**Example — Dockerfile for a Node.js app:**

```dockerfile
# Start from an official base image
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run when container starts
CMD ["node", "index.js"]
```

**Build and run your image:**

```bash
# Build the image from the Dockerfile in current directory
docker build -t my-app:latest .

# -t = tag (name:version)
# . = use Dockerfile in current directory

# Run your custom image
docker run -d -p 3000:3000 my-app:latest
```

---

## Part 8: Docker Logs

```bash
# View logs of a container
docker logs <container_id>

# Follow live logs (like tail -f)
docker logs -f <container_id>

# Last 50 lines only
docker logs --tail 50 <container_id>
```

---

## Quick Reference

```bash
# Images
docker pull <image>              # download image
docker images                    # list images
docker rmi <image_id>            # remove image

# Containers
docker run -d <image>            # run container in background
docker ps                        # list running containers
docker ps -a                     # list all containers
docker start <id>                # start container
docker stop <id>                 # stop container
docker rm <id>                   # remove container
docker exec -it <id> bash        # enter container shell
docker logs -f <id>              # live logs

# Volumes
docker volume create <name>      # create volume
docker volume ls                 # list volumes

# Build
docker build -t name:tag .       # build image from Dockerfile

# Cleanup
docker container prune           # remove stopped containers
docker image prune               # remove unused images
docker system prune              # remove everything unused ⚠️
```

---

## Common Patterns

### Run MySQL with persistent data and a custom network
```bash
docker network create app-network

docker run -d \
  --name mysql \
  --network app-network \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -e MYSQL_DATABASE=mydb \
  -v mysql-data:/var/lib/mysql \
  mysql:latest
```

### Run a web app that connects to MySQL
```bash
docker run -d \
  --name backend \
  --network app-network \
  -p 3000:3000 \
  -e DB_HOST=mysql \
  my-app:latest
```

> Both containers are on `app-network` so the backend can reach MySQL using the container name `mysql` as the hostname.

---

## Next Step — Kubernetes

Once you have multiple containers running, managing them manually becomes complex. Kubernetes automates:
- Restarting crashed containers
- Scaling up when traffic increases
- Rolling updates with zero downtime

> 📄 See `docker-theory.md` for why Kubernetes exists and how it fits in.
