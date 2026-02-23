# 📶 OSI Model — How Data Actually Travels

> A complete breakdown of the 7-layer model with a real message workflow from sender to receiver.

---

## What is the OSI Model?

The **OSI (Open Systems Interconnection) Model** is a framework that describes exactly how data moves from one device to another across a network — broken into 7 distinct layers, each with a specific job.

Think of it like a factory assembly line — each station adds something to the product before passing it to the next. On the receiving end, each station unwraps its layer in reverse.

> Mnemonic to remember the order (top to bottom):
> **P**lease **D**o **N**ot **T**hrow **S**ausages **P**izzas **A**way
> (Physical, Data Link, Network, Transport, Session, Presentation, Application)

---

## The 7 Layers at a Glance

```
Sender                                    Receiver
┌─────────────────────┐                  ┌─────────────────────┐
│ 7. Application      │ ─── internet ──▶ │ 7. Application      │
│ 6. Presentation     │                  │ 6. Presentation      │
│ 5. Session          │                  │ 5. Session           │
│ 4. Transport        │                  │ 4. Transport         │
│ 3. Network          │                  │ 3. Network           │
│ 2. Data Link        │                  │ 2. Data Link         │
│ 1. Physical         │                  │ 1. Physical          │
└─────────────────────┘                  └─────────────────────┘
   Data wraps down ↓                        Data unwraps up ↑
```

Data travels **down** the layers on the sender's side (each layer adds its own header/wrapper), and **up** the layers on the receiver's side (each layer strips its wrapper off).

---

## Each Layer Explained

### Layer 7 — Application
**What it does:** The layer closest to the user. This is where your actual apps live — browser, WhatsApp, email client. It handles what the data means and how it should be presented to the user.

**Protocols:** HTTP, HTTPS, SMTP, FTP, DNS

> Real-world: You type a message in WhatsApp. This layer is WhatsApp itself — it takes your "hi" and prepares it as data to be sent.

**PDU (unit of data):** Data

---

### Layer 6 — Presentation
**What it does:** Translates data into a format that both sides understand. Handles encryption, decryption, compression, and encoding.

> Real-world: Like a translator. If you write a letter in English but the recipient only reads French, this layer translates it. It also seals the envelope (encryption) so nobody can read it in transit.

**Examples:**
- Encrypting your WhatsApp message (Signal protocol / end-to-end encryption)
- Compressing a video file before sending
- Converting data to JPEG, MP3, or UTF-8 format

**PDU:** Data

---

### Layer 5 — Session
**What it does:** Manages the session — the opening, maintaining, and closing of a connection between two devices. If a connection drops mid-transfer, this layer can re-establish it and resume.

> Real-world: Like a phone call operator who connects the call, keeps it open while you talk, and hangs up when you're done. If the line drops, they reconnect you.

**Examples:**
- Maintaining your login session on a website
- Keeping a video call alive while data flows back and forth

**PDU:** Data

---

### Layer 4 — Transport
**What it does:** Breaks data into smaller pieces (segments), adds source/destination port numbers, and ensures reliable delivery if using TCP (or fast delivery if using UDP). Manages flow control and error checking.

> Real-world: Like a courier service that divides a large shipment into numbered boxes, sends them, and on the receiving end checks all boxes arrived and puts them back in order. If box 7 is missing, it requests it again.

**Key decisions made here:**
- Use **TCP** → guarantee delivery, order, re-send lost segments
- Use **UDP** → send fast, no re-sends, no guarantees

**PDU:** Segment (TCP) / Datagram (UDP)

---

### Layer 3 — Network
**What it does:** Handles logical addressing (IP addresses) and routing — figuring out the best path for packets to travel from source to destination across multiple networks and routers.

> Real-world: Like the national postal service. The package has a full address (IP), and each post office (router) along the way reads it and decides the next hop toward the destination.

**Key component:** **Router** — reads IP addresses and forwards packets toward their destination.

**PDU:** Packet

---

### Layer 2 — Data Link
**What it does:** Handles physical addressing (MAC addresses) for delivery within a local network. Packages data into **frames** and ensures error-free transmission between two directly connected devices.

> Real-world: Like internal mail within a building. The IP (Layer 3) gets the package to the right building. The MAC address (Layer 2) gets it to the right desk inside the building.

**Key components:**
- **Switch** — reads MAC addresses and forwards frames within a LAN
- **MAC Address** — a permanent hardware address burned into every network device by the manufacturer

**PDU:** Frame

---

### Layer 1 — Physical
**What it does:** The actual physical transmission of raw bits (0s and 1s) over a medium — whether that's copper cable, fiber optic, or wireless radio waves.

> Real-world: The actual roads, cables, and airwaves that carry everything. It doesn't know what the data means — it just moves the electrical signals or light pulses from A to B.

**Examples:** Ethernet cable, fiber optic, WiFi radio signal, Bluetooth

**PDU:** Bits

---

## MAC Address vs IP Address

A common point of confusion — both are "addresses" but they serve completely different purposes.

| | MAC Address | IP Address |
|--|-------------|------------|
| **Stands for** | Media Access Control | Internet Protocol |
| **Set by** | Device manufacturer (burned in permanently) | Your router / network admin (can change) |
| **Layer** | Layer 2 (Data Link) | Layer 3 (Network) |
| **Scope** | Local network only | Global internet |
| **Changes?** | No — permanent identity | Yes — can be reassigned |
| **Format** | `00:1A:2B:3C:4D:5E` | `192.168.1.1` |

> Real-world: MAC address is your national ID number — permanent, who you are. IP address is your current mailing address — where you are right now, which can change if you move.

---

## Complete Real-World Workflow

### Scenario: Linus sends "hi" to Tovey on WhatsApp

---

#### 🔽 Sending Side (Linus's phone) — Wrapping Down

**Layer 7 — Application**
Linus opens WhatsApp and types "hi". WhatsApp prepares this as data to send over the network.

**Layer 6 — Presentation**
WhatsApp encrypts the message using the Signal protocol (end-to-end encryption). Now the "hi" is scrambled — only Tovey's device can decrypt it. It's also encoded into the right format for transmission.

**Layer 5 — Session**
A session is established between Linus's phone and WhatsApp's server (or directly with Tovey if P2P). This session tracks the conversation context — who's talking to whom, keeping the connection alive.

**Layer 4 — Transport**
The data is broken into segments. TCP headers are added — including the source port (e.g., a dynamic port on Linus's phone) and destination port (443 for HTTPS). TCP ensures that if any segment is lost, it will be re-requested.

**Layer 3 — Network**
IP headers are added — Linus's IP address as the source, WhatsApp's server IP as the destination. The packet now knows where it needs to go on a global scale.

**Layer 2 — Data Link**
The packet is wrapped in a frame with Linus's phone MAC address as source and his home router's MAC address as destination. This handles the first local hop — phone → router.

**Layer 1 — Physical**
The bits are transmitted as radio waves over WiFi from Linus's phone to his home router.

---

#### 🌍 In Transit — Across the Internet

The data travels through multiple routers. At each router:
- Layer 1/2 unwraps the frame (local delivery done)
- Layer 3 reads the IP address and decides the next hop
- Layer 2 re-wraps in a new frame with the next router's MAC
- Layer 1 sends the bits onward

This repeats — hop by hop — until the packet reaches WhatsApp's server or Tovey's device.

---

#### 🔼 Receiving Side (Tovey's phone) — Unwrapping Up

**Layer 1 — Physical**
Tovey's phone receives the raw bits over WiFi.

**Layer 2 — Data Link**
The frame is opened. MAC address verified — this frame is for Tovey's phone. Header stripped.

**Layer 3 — Network**
The packet is opened. IP address confirmed — this is the right destination. Header stripped.

**Layer 4 — Transport**
Segments are reassembled in order. TCP confirms all segments arrived. If any are missing, it requests a re-send. Port number tells the phone to hand this to the right app (WhatsApp).

**Layer 5 — Session**
The session context is confirmed — this message belongs to the ongoing conversation between Linus and Tovey.

**Layer 6 — Presentation**
The encrypted data is decrypted using Tovey's private key. The "hi" is now readable again.

**Layer 7 — Application**
WhatsApp displays "hi" on Tovey's screen. ✅

---

## Summary Table

| Layer | Name | Job | PDU | Key Protocol/Device |
|-------|------|-----|-----|---------------------|
| 7 | Application | User-facing apps | Data | HTTP, SMTP, FTP, DNS |
| 6 | Presentation | Encrypt, compress, encode | Data | SSL/TLS, JPEG, UTF-8 |
| 5 | Session | Open/maintain/close connection | Data | Sessions, cookies |
| 4 | Transport | Segment data, ports, reliability | Segment / Datagram | TCP, UDP |
| 3 | Network | IP addressing, routing | Packet | IP, Router |
| 2 | Data Link | MAC addressing, local delivery | Frame | Ethernet, Switch |
| 1 | Physical | Raw bits over medium | Bits | Cable, WiFi, Fiber |
