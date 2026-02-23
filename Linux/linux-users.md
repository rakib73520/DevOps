# 👥 Linux — Users & Groups

---

## Users

```bash
whoami                          # show current logged-in user
sudo su                         # switch to root (superuser)
exit                            # exit current user / go back to previous

sudo useradd -m rakib           # create user (-m creates home directory)
sudo passwd rakib               # set password for user
su rakib                        # switch to user rakib
sudo userdel -r rakib           # delete user and their home directory

cat /etc/passwd                 # list all users on the system
id rakib                        # show uid, gid, and groups for a user
```

> 💡 `sudo` = "superuser do" — runs a command with admin privileges.
> ⚠️ Avoid staying in `sudo su` longer than needed — one wrong command affects the whole system.

---

## Groups

```bash
cat /etc/group                        # list all groups
getent group devops                   # list all users in the devops group

sudo groupadd devops                  # create a group
sudo groupdel devops                  # delete a group

sudo gpasswd -M suresh,rakib devops   # set members of devops group (replaces existing members)
sudo usermod -aG devops rakib         # add rakib to devops group (-a = append, -G = group)
```

> ⚠️ `gpasswd -M` **replaces** the group's member list. Use `usermod -aG` to add without removing others.

---

## File Ownership & Group Access

```bash
ls -l                                 # see file owner and group
sudo chgrp devops index.html          # change group owner of a file to devops
sudo chown rakib:devops index.html    # change both user and group owner
```

---

## Practical Example — Add User to Docker Group

```bash
sudo usermod -aG docker rakib         # add rakib to docker group
# rakib must log out and back in for the change to take effect

docker ps                             # verify — lists running docker containers
```

> After adding a user to a group, they need to **log out and log back in** for it to take effect.
