# 📁 Linux — Files & Directories

---

## Navigating

```bash
pwd               # show current directory path
ls                # list files
ls -l             # list with permissions, size, date
ls -la            # include hidden files (starting with .)
cd folder         # go into folder
cd ..             # go up one level
cd ~              # go to home directory
```

---

## Creating Files & Folders

```bash
touch file.txt                    # create an empty file
mkdir folder                      # create a folder
mkdir folder{1..20}               # create 20 folders: folder1, folder2 ... folder20
mkdir -p folder{001..120}         # create 120 folders with zero-padded names

# Create 120 folders and put a README.md inside each
mkdir -p folder{001..120} && touch folder{001..120}/README.md
```

---

## Moving & Renaming

```bash
mv oldname.txt newname.txt        # rename a file
mv file.txt folder/               # move file into a folder
mv log log.txt                    # change extension (rename log → log.txt)
cp file.txt backup.txt            # copy a file
cp -r folder/ backup/             # copy a folder recursively
```

---

## Deleting

```bash
rm file.txt                       # delete a file
rm -rf folder                     # delete a folder and everything inside it
rm -rf fold*                      # delete all items starting with "fold" (fold1, foldRakib, etc.)
```

> ⚠️ `rm -rf` is permanent — no trash/recycle bin. Double-check before running.

---

## Permissions

```bash
ls -l                             # view permissions for all files
```

Output example:
```
-rwxr--r-- 1 rakib devops 1024 Feb 24 file.txt
 ^^^------  ← user | group | others
```

| Symbol | Meaning |
|--------|---------|
| `r` | read (4) |
| `w` | write (2) |
| `x` | execute (1) |
| `-` | no permission (0) |

```bash
chmod 700 app.sh       # owner: full access | group: none | others: none
chmod 214 file.txt     # owner: write | group: execute | others: read
chmod +x app.sh        # just add execute permission
```

> 💡 Permission numbers: add r+w+x values together. e.g. `7 = 4+2+1 = rwx`, `5 = 4+1 = r-x`

---

## Copying Files to a Remote Server (SCP)

```bash
scp -i key.pem file.txt ubuntu@<server-ip>:/home/ubuntu/
```

> Copies a local file to a remote EC2 instance over SSH.
> 📄 See `ec2.md` for connecting to EC2.
