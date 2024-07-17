# Load environment variables from .env file
export $(grep -v '^#' .env-release | xargs)

# Example command to build .deb package for Debian Buster (10)
dpkg-deb --build . ./pool/d2d-1.0.deb

# Example command to build .deb package for Debian Buster (10)
# dpkg-deb --build . ./pool/d2d-1.0-buster.deb

# Example command to build .deb package for Debian Bullseye (11)
# dpkg-deb --build . ./pool/d2d-1.0-bullseye.deb

cd dists/bullseye 

apt-ftparchive packages ../../pool/ > Packages

apt-ftparchive release . > Release

gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release

cd ../../

cd dists/buster 

apt-ftparchive packages ../../pool/ > Packages

apt-ftparchive release . > Release

gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release


cd ../../

cd dists/stable 

apt-ftparchive packages ../../pool/ > Packages

apt-ftparchive release . > Release

gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release


# DOCUMENTATION:
# 1. **Command Purpose**:
#    - The `dpkg-deb --build` command is used to create Debian packages (`.deb`) from the current directory (`.`) and its contents.

# 2. **Command Syntax**:
#    - To create a Debian package named `d2d-1.0-buster.deb` in the `./pool/` directory for Debian Buster (10):
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0-buster.deb
#      ```
#    - To create a Debian package named `d2d-1.0-bullseye.deb` in the `./pool/` directory for Debian Bullseye (11):
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0-bullseye.deb
#      ```

# 3. **Usage Instructions**:
#    - Ensure that all necessary files, directories, and configuration files required for packaging the `d2d` CLI tool are present in the current directory (`.`) before running each command.
#    - Adjust the target `.deb` filename (`d2d-1.0-buster.deb`, `d2d-1.0-bullseye.deb` in these examples) and destination directory (`./pool/`) as per your project's naming conventions and organizational requirements.

# 4. **Example Usage**:
#    - To build a Debian package named `d2d-1.0-buster.deb` for Debian Buster (10), execute:
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0-buster.deb
#      ```
#    - To build a Debian package named `d2d-1.0-bullseye.deb` for Debian Bullseye (11), execute:
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0-bullseye.deb
#      ```

# 5. **Important Notes**:
#    - Ensure that the current directory (`.`) contains all necessary files, executable scripts, configuration files, and permissions required for the `d2d` CLI tool to function correctly after installation.
#    - Adjust file paths, names, and package versions (`1.0` in these examples) according to your project's specifications and versioning guidelines.
#    - Each `dpkg-deb --build` command creates a separate `.deb` package in the specified destination directory (`./pool/`).
