#!/usr/bin/env bash

# Extract the NiFi version from the Dockerfile or relevant file
VERSION=$(grep 'ARG NIFI_VERSION=' Dockerfile | cut -d '=' -f 2 | tr -d '[:space:]')

if [ -z "$VERSION" ]; then
    echo "Error: Could not extract NIFI_VERSION from Dockerfile."
    exit 1
fi

# Set variables for checksum and PGP files
SHA512_FILE_URL="https://archive.apache.org/dist/nifi/${VERSION}/nifi-${VERSION}-bin.zip.sha512"
CHECKSUM_FILE="nifi-${VERSION}-bin.zip.sha512"
PGP_FILE_URL="https://archive.apache.org/dist/nifi/${VERSION}/nifi-${VERSION}-bin.zip.asc"
PGP_FILE="nifi-${VERSION}-bin.zip.asc"

# Download the SHA-512 checksum file
echo "Downloading SHA-512 checksum file for NiFi version $VERSION..."
curl -L "$SHA512_FILE_URL" -o "$CHECKSUM_FILE"

# Download the PGP signature file
echo "Downloading PGP signature file for NiFi version $VERSION..."
curl -L "$PGP_FILE_URL" -o "$PGP_FILE"

# Commit and push changes
git add "$CHECKSUM_FILE" "$PGP_FILE"
git commit -m "Add SHA-512 checksum and PGP signature for NiFi version $VERSION"
git push

echo "Checksum and PGP signature files updated and committed successfully."
