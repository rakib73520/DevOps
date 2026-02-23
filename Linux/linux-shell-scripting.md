# 🐚 Linux — Shell Scripting

---

## What is a Shell?

A shell is the program that reads your commands and runs them. Common shells:

| Shell | Name | Notes |
|-------|------|-------|
| `sh` | Bourne Shell | The original, minimal |
| `bash` | Bourne Again Shell | Most common on Linux |
| `zsh` | Z Shell | Default on macOS, more features |
| Git Bash | — | Linux emulator for Windows |

> 💡 Most scripts use `bash`. Check your shell with: `echo $SHELL`

---

## Creating & Running a Script

```bash
# 1. Create the script file
touch app.sh

# 2. Make it executable
chmod +x app.sh

# 3. Run it
./app.sh

# Alternative — run without making it executable
bash app.sh
```

---

## Script Structure

Every bash script starts with a **shebang** line — tells the system which shell to use:

```bash
#!/bin/bash
# ^ shebang: # = "she", ! = "bang"

echo "Hello World"
```

> ⚠️ The shebang must be the **very first line** of the file — no blank lines before it.

---

## Variables

```bash
#!/bin/bash

name="rakib"                    # declare variable (no spaces around =)
echo "Hello $name"              # use variable with $
echo "Hello ${name}!"           # use variable inside a string (safer with {})

# Single quotes = literal (no variable expansion)
echo '$name'                    # prints: $name

# Double quotes = expands variables
echo "$name"                    # prints: rakib
```

> ⚠️ No spaces around `=` when declaring variables. `name = "rakib"` will throw an error.

---

## User Input

```bash
#!/bin/bash

echo "Enter your name:"
read name

echo "Enter your email:"
read email

echo "Welcome $name, your email is $email"
```

```bash
# Read with prompt in one line
read -p "Enter your name: " name
```

---

## Conditionals

```bash
#!/bin/bash

read -p "Enter a number: " num

if [ $num -gt 10 ]; then
  echo "Greater than 10"
elif [ $num -eq 10 ]; then
  echo "Equal to 10"
else
  echo "Less than 10"
fi
```

**Comparison operators:**

| Operator | Meaning |
|----------|---------|
| `-eq` | equal |
| `-ne` | not equal |
| `-gt` | greater than |
| `-lt` | less than |
| `-ge` | greater than or equal |
| `-le` | less than or equal |

---

## Loops

```bash
#!/bin/bash

# Loop through numbers
for i in {1..5}; do
  echo "Number: $i"
done

# Loop through files
for file in *.log; do
  echo "Processing $file"
done

# While loop
count=1
while [ $count -le 5 ]; do
  echo "Count: $count"
  count=$((count + 1))
done
```

---

## Functions

```bash
#!/bin/bash

greet() {
  echo "Hello, $1!"       # $1 = first argument passed to function
}

greet "Rakib"             # prints: Hello, Rakib!
greet "John"              # prints: Hello, John!
```

---

## Practical Example — Backup Script

```bash
#!/bin/bash

SOURCE="/home/ubuntu/project"
DEST="/home/ubuntu/backups"
DATE=$(date +%Y-%m-%d)

echo "Starting backup..."
cp -r $SOURCE $DEST/project-$DATE
echo "✅ Backup saved to $DEST/project-$DATE"
```

---

## Quick Reference

```bash
#!/bin/bash               # always first line
chmod +x app.sh           # make executable
./app.sh                  # run script
bash app.sh               # run without executable permission

name="value"              # declare variable
echo "$name"              # print variable
read name                 # take user input
read -p "prompt: " name   # prompt + read in one line

if [ condition ]; then    # conditional
for i in {1..10}; do      # loop
$(command)                # capture command output into a variable
```
