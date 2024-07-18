#!/bin/bash

# This script automates the process of updating the package list, installing necessary tools, 
# building .deb packages, and generating package index and release files for various Debian distributions.

# Update the package list
sudo apt-get update

# Install necessary tools for building Debian packages
sudo apt-get install dpkg-dev debhelper devscripts apt-utils

# Load environment variables from .env file
export $(grep -v '^#' .env-release | xargs)

# Create a new changelog entry for the d2d package
dch --create --package d2d --newversion 1.0 --distribution stable

# Example command to build .deb package for Debian Buster (10)
dpkg-deb --build . ./pool/d2d-1.0.deb

# Uncomment the following lines to build .deb packages for other Debian distributions
# dpkg-deb --build . ./pool/d2d-1.0-bullseye.deb
# dpkg-deb --build . ./pool/d2d-1.0-buster.deb

# Change directory to the parent directory
cd ../

# Build the source package for d2d
dpkg-source -b d2d-dhis-docker-implementation

# Change directory back to the implementation directory
cd d2d-dhis-docker-implementation

# Build the binary package without signing the changes and build info files
dpkg-buildpackage -us -uc

# Move the generated files to the pool/main directory
mv ../d2d_1.0.dsc ./pool/main/
mv ../d2d_1.0.tar.gz ./pool/main/
mv ../d2d_1.0_all.deb ./pool/main/

# Clean up the parent directory
cd ..
rm *.dsc *.tar.xz *.tar.gz *.diff.gz *.deb *.buildinfo *.changes *Release*

# Change back to the implementation directory
cd d2d-dhis-docker-implementation

# Generate source indexes and compress them for each distribution
dpkg-scansources pool/main > dists/stable/main/source/Sources
gzip -9c dists/stable/main/source/Sources > dists/stable/main/source/Sources.gz

dpkg-scansources pool/main > dists/bullseye/main/source/Sources
gzip -9c dists/bullseye/main/source/Sources > dists/bullseye/main/source/Sources.gz

dpkg-scansources pool/main > dists/buster/main/source/Sources
gzip -9c dists/buster/main/source/Sources > dists/buster/main/source/Sources.gz

# Generate package index and release files for Debian Bullseye
cd dists/bullseye/main/binary-amd64
apt-ftparchive packages ../../../../pool/ > Packages
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
cd ../../
apt-ftparchive release . > Release
gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
cd ../../

# Generate package index and release files for Debian Buster
cd dists/buster/main/binary-amd64 
apt-ftparchive packages ../../../../pool/ > Packages
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
cd ../../
apt-ftparchive release . > Release
gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
cd ../../

# Generate package index and release files for the stable distribution
cd dists/stable/main/binary-amd64 
apt-ftparchive packages ../../../../pool/ > Packages
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
cd ../../
apt-ftparchive release . > Release
gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
cd ../../

# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script automates the process of updating the package list, installing necessary tools,
#      building .deb packages, and generating package index and release files for various Debian distributions.

# 2. **Steps Performed by the Script**:
#    - Updates the package list using `sudo apt-get update`.
#    - Installs required tools (`dpkg-dev`, `debhelper`, `devscripts`, `apt-utils`) using `sudo apt-get install`.
#    - Loads environment variables from the `.env-release` file.
#    - Creates a new changelog entry for the `d2d` package using `dch`.
#    - Builds .deb packages for the `d2d` tool using `dpkg-deb --build`.
#    - Builds the source package using `dpkg-source -b`.
#    - Builds the binary package without signing using `dpkg-buildpackage -us -uc`.
#    - Moves the generated files (`.dsc`, `.tar.gz`, `.deb`) to the `pool/main` directory.
#    - Cleans up the parent directory by removing unnecessary files.
#    - Generates source indexes and compresses them using `dpkg-scansources` and `gzip`.
#    - Generates package index and release files for various Debian distributions (`bullseye`, `buster`, `stable`)
#      using `apt-ftparchive` and `gpg`.

# 3. **Usage Instructions**:
#    - Ensure that all necessary files, directories, and configuration files required for packaging the `d2d` CLI tool 
#      are present in the current directory (`.`) before running the script.
#    - Adjust the target `.deb` filenames and destination directories as per your project's naming conventions and 
#      organizational requirements.
#    - Modify the distribution names (`bullseye`, `buster`, `stable`) in the commands for generating package index and 
#      release files based on the Debian distribution you are targeting.

# 4. **Example Usage**:
#    - To build a Debian package named `d2d-1.0.deb`, execute:
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0.deb
#      ```
#    - To generate package index and release files for Debian Bullseye (11), Debian Buster (10), and stable distribution,
#      execute the respective commands under `Command to generate package index and release files`.

# 5. **Important Notes**:
#    - Ensure that the current directory (`.`) contains all necessary files, executable scripts, configuration files, 
#      and permissions required for the `d2d` CLI tool to function correctly after installation.
#    - Adjust file paths, names, and package versions (`1.0` in this example) according to your project's specifications 
#      and versioning guidelines.
#    - Each `dpkg-deb --build` command creates a separate `.deb` package in the specified destination directory (`./pool/`).
#    - Verify the contents and functionality of the generated `.deb` packages (`d2d-1.0.deb`) and release files to ensure 
#      they include all required components and perform as expected during installation and usage.
