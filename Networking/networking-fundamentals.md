# 🌐 Computer Networking — Fundamentals

> The building blocks of how the internet works, explained with real-world analogies.

---

## What is the Internet?

The internet is simply a massive collection of computers connected together worldwide — billions of devices all talking to each other using agreed-upon rules called **protocols**.

Think of it like a global postal system:

| Postal World | Internet Equivalent |
|-------------|---------------------|
| Your home address | IP Address |
| Postman | HTTP (delivers the data) |
| Letter/package | Data |
| Post office routing | Router |
| Roads and highways | Network cables / WiFi |
| Language on the letter | Protocol |

Without agreed rules (protocols), computers would be like two people trying to talk — one speaking Bengali, one speaking Japanese. Protocols are the common language.

---

## Protocols — The Rules of Communication

A **protocol** is a set of rules two computers agree to follow when communicating. Like a handshake agreement — both sides know what to expect.

| Protocol | Full Name | Used For |
|----------|-----------|----------|
| **TCP/IP** | Transmission Control Protocol / Internet Protocol | The foundation of the internet — reliable delivery + routing |
| **UDP** | User Datagram Protocol | Speed over reliability (live video, gaming, DNS) |
| **HTTP** | HyperText Transfer Protocol | Loading websites |
| **HTTPS** | HTTP Secure | Encrypted web browsing |
| **FTP** | File Transfer Protocol | Transferring files between computers |
| **SMTP** | Simple Mail Transfer Protocol | Sending emails |
| **DNS** | Domain Name System | Translating domain names to IP addresses |

### TCP vs UDP — Reliability vs Speed

**TCP** makes sure every single packet arrives and arrives in order. If something gets lost, it re-sends it. This is why web pages, file downloads, and emails use TCP — you need the complete, correct data.

**UDP** fires data as fast as possible without checking if it arrived. Some packets might get dropped — but that's acceptable when speed matters more than perfection.

> Real-world: TCP is like sending a registered letter — you get a confirmation it arrived safely. UDP is like a live phone call — if a word cuts out, you don't replay it, you just keep going.

| | TCP | UDP |
|--|-----|-----|
| **Delivery guarantee** | ✅ Yes | ❌ No |
| **Order guarantee** | ✅ Yes | ❌ No |
| **Speed** | Slower (more overhead) | Faster |
| **Use case** | Web, email, file transfer | Video calls, gaming, live streams |

---

## IP Address & DNS

Every device connected to the internet has an **IP address** — a unique numerical identifier, like a home address.

Example IP: `142.250.185.46`

But nobody memorizes IPs. That's where **DNS (Domain Name System)** comes in.

When you type `google.com`:
1. Your browser asks a DNS server: *"What's the IP for google.com?"*
2. DNS replies: `142.250.185.46`
3. Your browser connects to that IP address

> Real-world: DNS is the phonebook of the internet. You look up "Google" and get back a phone number (IP address). Without DNS, you'd have to memorize numbers for every website.

---

## Packets — Breaking Data Into Pieces

When you send a large file or load a webpage, the data doesn't travel as one big chunk. It gets broken into small pieces called **packets**, each sent independently and reassembled at the destination.

> Real-world: Imagine sending a 500-page book through the mail. Instead of one giant parcel, you tear it into individual pages, put each in its own envelope, and mail them separately. They might take different routes and arrive in different orders — but at the other end, they're reassembled into the complete book. If page 47 gets lost, only page 47 needs to be re-sent.

This is why your internet doesn't completely die when one cable is congested — packets just take a different route.

---

## Routers

A **router** is a device that decides where packets go. It reads the destination IP on each packet and forwards it toward the right destination — passing it from router to router until it arrives.

> Real-world: Each post office along the route looks at the address on the envelope and decides which direction to send it next. It doesn't need to know the full route — just the next hop.

Your home WiFi router does this too — it routes traffic between your devices and your ISP (Internet Service Provider).

---

## LAN vs WAN

| | LAN | WAN |
|--|-----|-----|
| **Full Name** | Local Area Network | Wide Area Network |
| **Scale** | One room, office, or building | City → country → the entire world |
| **Speed** | Very fast (Gbps) | Slower (limited by distance) |
| **Example** | 10 computers sharing one office printer | The internet itself |

> Real-world: LAN is your apartment building's internal intercom system. WAN is the national telephone network.

---

## Client-Server Model

Most of the internet works on this simple model:

```
You (Client) ──── "give me amazon.com" ────▶ Amazon's Server
             ◀──── here's the webpage ──────
```

- **Client** — the one making the request (your browser, your app)
- **Server** — the one responding with data (Amazon, Google, Netflix)

Every time you open a website, watch a video, or send a message — a client is requesting something from a server somewhere.

---

## Ports — Which Service Gets the Knock

An **IP address** gets a packet to the right device. A **port number** tells that device which application should handle it.

> Real-world: The IP address is your apartment building. The port is the flat number. Both are needed to reach the right person.

| Port Range | Type | Examples |
|------------|------|---------|
| 0 – 1023 | Well-Known Ports | HTTP (80), HTTPS (443), SSH (22), SMTP (25) |
| 1024 – 49151 | Registered Ports | MySQL (3306), MongoDB (27017), PostgreSQL (5432) |
| 49152 – 65535 | Dynamic / Private | Temporary ports assigned by your browser per tab |

When you open a website on HTTPS, your browser connects to port `443` on the server's IP. Your SSH connection to EC2 goes through port `22`.

---

## Bits vs Bytes — A Common Confusion

- **Internet speed** is measured in **bits** — e.g., `100 Mbps`
- **File sizes** are measured in **bytes** — e.g., `50 MB`
- `1 byte = 8 bits`

So a `100 Mbps` connection downloads `100 Megabits` per second — which is only `12.5 Megabytes` per second.

> That's why a 100 MB file takes ~8 seconds on a "100 Mbps" connection, not 1 second. ISPs advertise in bits (the bigger number), file sizes are in bytes (the smaller unit).

---

## Firewalls & Security

A **firewall** monitors and filters all incoming and outgoing network traffic based on rules you define. It blocks anything that doesn't match the allowed rules.

> Real-world: Like a security guard at a building entrance — checks everyone's ID, only lets in people on the approved list, turns away everyone else.

In AWS, **Security Groups** act as firewalls for your EC2 instances — you define exactly which ports and IP ranges are allowed in.
📄 See `security-group.md` for setup.

### Encryption

When data travels over the internet, it can be intercepted. Encryption scrambles the data so only the intended recipient can read it.

**Symmetric Encryption** — both sender and receiver use the same secret key.
> Like a shared padlock — whoever has the key can lock and unlock.

**Asymmetric Encryption** — uses two keys: a **public key** (anyone can use to encrypt) and a **private key** (only you can use to decrypt). Used in HTTPS and SSH.
> Like a letterbox — anyone can drop a letter in (public key), but only you have the key to open the box (private key).

---

## Network Topologies

A **topology** is how devices are physically or logically arranged and connected to each other.

### 🚌 Bus
All devices share one single cable. Simple and cheap but a single break in the cable takes down everything.
> Like a single power strip — if it breaks, every device loses power.

### ⭐ Star
All devices connect to a central hub or switch. Most common setup — home WiFi, office networks. Easy to add or remove devices. If the hub fails, everything goes down.
> Like a wheel — all spokes connect to the center. Strong center = strong network.

### 🔁 Ring
Devices connected in a closed loop. Data travels in one direction around the ring. High bandwidth but adding/removing devices is disruptive and one break can affect the whole ring.

### 🕸️ Mesh
Every device connects to every other device. Extremely reliable — if one connection breaks, data finds another path automatically. Very expensive and complex to manage.
> Used in military communications and critical infrastructure where failure is not an option.

### 🌳 Tree
Devices arranged in a parent-child hierarchy, like branches of a tree. Easy to expand by adding new branches.
> Real-world: An ISP expanding coverage — main hub → city → district → neighbourhood → your street → your home.
