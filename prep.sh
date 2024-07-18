#!/bin/bash
# Pre-installation script for d2d CLI

# Copy necessary files to DEBIAN directory
cp ./debian/postinst ./DEBIAN
cp ./debian/changelog ./DEBIAN
cp ./debian/compat ./DEBIAN
cp ./debian/rules ./DEBIAN
cp ./debian/prerm ./DEBIAN
cp ./debian/source/format ./DEBIAN/source/
cp ./bin/d2d usr/local/bin/

# Set execute permissions for files in debian and DEBIAN directories
chmod +x ./debian/control
chmod +x ./debian/postinst
chmod +x ./debian/prerm
chmod +x ./DEBIAN/control
chmod +x ./DEBIAN/postinst
chmod +x ./DEBIAN/prerm
chmod +x usr/local/bin/d2d
chmod +x d2d-completion.sh


# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script prepares the necessary files and sets permissions for installing the d2d CLI tool.

# 2. **Steps Performed by the Script**:
#    - Copies essential installation files (`postinst`, `changelog`, `compat`, `rules`, `prerm`, `source/format`) from the `debian` directory to the `DEBIAN` directory for package installation.
#    - Copies the `d2d` executable from the `bin` directory to `/usr/local/bin/`.
#    - Sets execute permissions for the `control`, `postinst`, and `prerm` scripts in both `debian` and `DEBIAN` directories.
#    - Sets execute permissions for the `d2d` executable in `/usr/local/bin/`.
#    - Sets execute permissions for the `d2d-completion.sh` script.

# 3. **Usage Instructions**:
#    - Place this script in a suitable location within your installation process for the d2d CLI.
#    - Ensure that the necessary files (`postinst`, `changelog`, `compat`, `rules`, `prerm`, `source/format`, and `d2d`) are present in their respective directories before running this script.
#    - Run this script as a part of the d2d CLI installation process.

# 4. **Example Usage**:
#    - To run this script before installing the d2d CLI, execute: `sudo ./pre_install.sh`

# 5. **Error Handling**:
#    - The script assumes that all necessary files (`postinst`, `changelog`, `compat`, `rules`, `prerm`, `source/format`, and `d2d`) are present in their respective directories. Ensure their availability to avoid errors.
#    - Ensure that appropriate permissions are set for executing this script and modifying system directories.

# 6. **Important Notes**:
#    - This script should be run with root privileges to modify files in `/usr/local/bin` and `/DEBIAN`.
#    - Verify the paths and permissions according to your system configuration and security policies.

# 7. **Expected Output**:
#    - Copies necessary files to `DEBIAN` directory and `/usr/local/bin/`.
#    - Sets execute permissions for installation scripts and the `d2d` executable.