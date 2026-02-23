# 📊 Linux — Services & Monitoring

---

## Managing Services (systemctl)

```bash
systemctl list-units                  # list all active services
systemctl status ssh                  # show status of a service
systemctl start docker                # start a service
systemctl stop docker                 # stop a service
systemctl restart docker              # restart a service
systemctl enable docker               # auto-start on boot
systemctl disable docker              # don't auto-start on boot
```

---

## Viewing Logs (journalctl)

```bash
sudo journalctl -fu docker.service    # live log stream for docker (-f = follow, -u = unit)
sudo journalctl -u ssh --since today  # logs for ssh since today
sudo journalctl -n 50                 # last 50 log lines
```

---

## Searching Logs (grep)

```bash
grep -i 'error' app.log              # find lines containing "error" (case-insensitive)
grep -i 'error' app.log | wc -l      # count how many error lines
grep -i 'error\|warn' app.log        # find lines with "error" OR "warn"
```

> `-i` = case insensitive (matches ERROR, Error, error)

---

## Extracting Columns (awk)

```bash
awk '{print $4, $7}' app.log              # print 4th and 7th column from every line
awk '/ERROR/ {print $4, $7}' app.log      # only print columns from lines containing ERROR
awk -F',' '{print $1, $3}' data.csv       # use comma as delimiter (for CSV files)
```

> 💡 `awk` treats spaces as column separators by default. Each word = one column (`$1`, `$2`, etc.)

---

## Finding Files (find)

```bash
find /path/ -name "*.log"              # find all .log files in a path
find . -name "*.log"                   # find all .log files from current directory
find . -mtime 0                        # files modified in the last 24 hours
find . -mtime +1                       # files modified more than 1 day ago
find . -mtime -7                       # files modified in the last 7 days
find . -name "*.log" -delete           # find and delete all .log files
```

---

## Find & Replace in Files (sed)

```bash
# Preview replacement (does NOT change the file)
sed 's/Rakib/JohnSnow/' rakib.txt

# Replace and save to a NEW file
sed 's/Rakib/JohnSnow/' rakib.txt > johnsnow.txt

# Replace IN the original file
sed -i 's/Rakib/JohnSnow/' rakib.txt

# Replace ALL occurrences per line (default only replaces first match per line)
sed 's/Rakib/JohnSnow/g' rakib.txt
```

> 💡 Without `-i`, `sed` only prints to the console — the original file is unchanged.
> The `g` flag at the end means **global** — replace every match on each line, not just the first.

---

## Package Management (apt)

```bash
sudo apt update                            # refresh package list
sudo apt install docker.io -y             # install package (-y = auto-yes to all prompts)
sudo apt remove docker.io                 # remove package (keep config files)
sudo apt purge docker.io                  # remove package AND config files
sudo apt list --installed | grep docker   # check if a package is installed
```

---

## Quick Reference

| Tool | Use For |
|------|---------|
| `systemctl` | Start/stop/enable services |
| `journalctl` | View service logs |
| `grep` | Search for text in files |
| `awk` | Extract specific columns from output |
| `find` | Locate files by name, date, type |
| `sed` | Find and replace text in files |
