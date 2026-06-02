#!/bin/bash

set -e

echo "=============================="
echo " Installing OpenJDK 21 (Temurin)"
echo "=============================="

JAVA_DIR="/usr/lib/jvm/java-21-temurin"
TMP_DIR="/opt/java21-install"

# 1. Cleanup old Java (safe step)
echo "[1/6] Removing old OpenJDK packages..."
dnf remove -y "*openjdk*" || true

# 2. Create temp directory
echo "[2/6] Preparing workspace..."
mkdir -p $TMP_DIR
cd $TMP_DIR

# 3. Download Java 21 (Adoptium API - stable)
echo "[3/6] Downloading OpenJDK 21..."
curl -L -o jdk21.tar.gz https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jdk/hotspot/normal/eclipse

# 4. Extract
echo "[4/6] Extracting..."
tar -xzf jdk21.tar.gz

# Find extracted folder
JDK_FOLDER=$(ls -d jdk* | head -n 1)

# 5. Move to standard location
echo "[5/6] Installing to $JAVA_DIR..."
mkdir -p /usr/lib/jvm
mv "$JDK_FOLDER" "$JAVA_DIR"

# 6. Configure alternatives
echo "[6/6] Configuring system Java..."

alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 2
alternatives --set java $JAVA_DIR/bin/java

# Set JAVA_HOME system-wide
cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=$JAVA_DIR
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

source /etc/profile.d/java.sh

echo "=============================="
echo " Java Installation Completed"
echo "=============================="

java -version
which java
readlink -f $(which java)

echo "DONE ✔"
