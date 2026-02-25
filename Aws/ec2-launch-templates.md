# 📋 AWS EC2 Launch Templates

> Create a reusable, versioned template directly from an existing EC2 instance.
> 📄 To create an EC2 instance first — see `ec2.md`.

---

## Part 1: Create Template from an Existing Instance (v1)

**1.** EC2 → **Instances** → select your running instance

**2.** Click **"Actions"** → **"Image and templates"** → **"Create template from instance"**

**3.** Fill in template details:
- **Launch template name:** `my-app-template`
- **Template version description:** `v1`

**4.** All settings (AMI, instance type, key pair, security group, storage) are **auto-filled** from the selected instance — no need to re-enter anything.

**5.** Scroll down to **"Advanced details"** → find **"User data"** → paste:

```bash
#!/bin/bash
sudo apt update -y
```

> `#!/bin/bash` tells the system to run this as a bash script.
> This script runs automatically on the **first boot** of any instance launched from this template.

**6.** Click **"Create launch template"** ✅

---

## Part 2: Modify Template — Create v2

**1.** EC2 → left sidebar → **"Launch Templates"** → select `my-app-template`

**2.** Click **"Actions"** → **"Modify template (Create new version)"**

**3.** Set version description:
- **Template version description:** `v2`
- **Source template version:** `1` *(all v1 settings pre-filled)*

**4.** Scroll to **"Storage (volumes)"** → find the EBS volume at **Device index 0**

**5.** Click the **"Don't include"** toggle / checkbox on that volume

> ⚠️ **Important correction:** In AWS, you cannot actually exclude index 0 (the root volume) — without it the instance has no OS and won't boot. What "Don't include" applies to is any **additional volumes** (index 1+) that were attached to the original instance. If the original instance had extra EBS volumes, you can choose not to carry them into this template version.

**6.** Click **"Create launch template version"** ✅

---

## Part 3: Launch Instance from Template

**1.** EC2 → **"Launch Templates"** → select `my-app-template`

**2.** Click **"Actions"** → **"Launch instance from template"**

**3.** Under **"Source template version"** → select `1` or `2`

**4.** Adjust number of instances if needed

**5.** Click **"Launch instance"** ✅

---

## Managing Versions

- **Set default version:** Actions → "Set default version"
- **View all versions:** select template → **"Versions"** tab
- **Delete a version:** select version → Actions → Delete *(change default first if deleting the default)*

---

## Debugging User Data

SSH into the launched instance and check if the startup script ran:

```bash
cat /var/log/cloud-init-output.log
```
