#!/bin/bash

# Variables
PACKAGE_NAME="d2d"
VERSION="1.0"
ARCH="all"
MAINTAINER="Walter V. Faustine <waltervfaustine@gmail.com>"

# Build source package
dpkg-source --build .

# Build binary package
dpkg-buildpackage -us -uc

# Move generated files to dist directory
mv ../${PACKAGE_NAME}_${VERSION}_${ARCH}.deb ../${PACKAGE_NAME}_${VERSION}.dsc ../${PACKAGE_NAME}_${VERSION}.tar.xz dist/

# Test the package
sudo dpkg -i ../${PACKAGE_NAME}_${VERSION}_${ARCH}.deb

# Publish to GitHub (manual step)
echo "Please go to your GitHub repository and create a release to upload the generated files."

# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script automates the process of building a Debian package for the `d2d` tool, including source and binary packages,
#      and moves the generated files to the `dist` directory for easier access and distribution.

# 2. **Variables**:
#    - `PACKAGE_NAME`: The name of the package being created, in this case, "d2d".
#    - `VERSION`: The version of the package, currently set to "1.0".
#    - `ARCH`: The architecture type for the package, set to "all" to indicate compatibility with all architectures.
#    - `MAINTAINER`: The maintainer's information, including name and email.

# 3. **Build Source Package**:
#    - Uses the `dpkg-source` command to build the source package from the current directory.

# 4. **Build Binary Package**:
#    - Uses the `dpkg-buildpackage` command to build the binary package without signing the source (`-us`) or the changes (`-uc`).

# 5. **Move Generated Files**:
#    - Moves the generated Debian package files (`.deb`, `.dsc`, `.tar.xz`) to the `dist` directory for easier organization.

# 6. **Test the Package**:
#    - Installs the generated Debian package using the `dpkg -i` command to ensure it installs correctly on the system.

# 7. **Publish to GitHub**:
#    - Provides a reminder to manually upload the generated package files to the GitHub repository by creating a release.
#    - The upload process is not automated within this script.

# 8. **Important Notes**:
#    - Ensure the necessary build dependencies are installed on the system before running this script.
#    - Verify that the `dist` directory exists or create it before running the script to avoid errors during file moving.
#    - Check the package's compatibility and installation process in a test environment before distributing widely.

# 9. **Example Usage**:
#    - To build the `d2d` Debian package, simply run the script: `./build-d2d-package.sh`
#    - Ensure the script has execution permissions: `chmod +x build-d2d-package.sh`

# 10. **Expected Output**:
#    - A Debian package (`d2d_1.0_all.deb`) and associated files (`.dsc`, `.tar.xz`) will be generated and moved to the `dist` directory.
#    - The package will be installed on the system for testing purposes.