#!/usr/bin/env bash

# Extract the NiFi version from the Dockerfile or relevant file
VERSION=$(grep 'ARG NIFI_VERSION=' Dockerfile | cut -d '=' -f 2 | tr -d '[:space:]')

if [ -z "$VERSION" ]; then
    echo "Error: Could not extract NIFI_VERSION from Dockerfile."
    exit 1
fi

# Delete old Checksum and PGP files
find . -name 'nifi-/d+/d+/d+-bin.zip.(asc|sha512)' -delete
ls

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

echo "Checksum and PGP signature files updated successfully."
