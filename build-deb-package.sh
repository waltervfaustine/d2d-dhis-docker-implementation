# Load environment variables from .env file
export $(grep -v '^#' .env-release | xargs)

# Example command to build .deb package for Debian Buster (10)
dpkg-deb --build . ./pool/d2d-1.0.deb

# Example command to build .deb package for Debian Bullseye (11)
# dpkg-deb --build . ./pool/d2d-1.0-bullseye.deb

# Example command to build .deb package for Debian Buster (10)
# dpkg-deb --build . ./pool/d2d-1.0-buster.deb

# Command to generate package index and release files for Debian Bullseye
cd dists/bullseye 
apt-ftparchive packages ../../pool/ > Packages
apt-ftparchive release . > Release
gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
cd ../../

# Command to generate package index and release files for Debian Buster
cd dists/buster 
apt-ftparchive packages ../../pool/ > Packages
apt-ftparchive release . > Release
gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
cd ../../

# Command to generate package index and release files for stable distribution
cd dists/stable 
apt-ftparchive packages ../../pool/ > Packages
apt-ftparchive release . > Release
gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
cd ../../

# DOCUMENTATION:
# 1. **Command Purpose**:
#    - The `dpkg-deb --build` command is used to create Debian packages (`.deb`) from the current directory (`.`) and its contents.

# 2. **Command Syntax**:
#    - To create a Debian package named `d2d-1.0.deb` in the `./pool/` directory:
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0.deb
#      ```
#    - To create Debian package index and release files for different Debian distributions:
#      ```
#      cd dists/<distribution_name>
#      apt-ftparchive packages ../../pool/ > Packages
#      apt-ftparchive release . > Release
#      gpg --default-key ${GPG_KEY} --output Release.gpg -ba Release
#      cd ../../
#      ```

# 3. **Usage Instructions**:
#    - Ensure that all necessary files, directories, and configuration files required for packaging the `d2d` CLI tool are present in the current directory (`.`) before running each command.
#    - Adjust the target `.deb` filename (`d2d-1.0.deb` in this example) and destination directory (`./pool/`) as per your project's naming conventions and organizational requirements.
#    - Modify `<distribution_name>` in the commands for generating package index and release files (`bullseye`, `buster`, `stable`) based on the Debian distribution you are targeting.

# 4. **Example Usage**:
#    - To build a Debian package named `d2d-1.0.deb`, execute:
#      ```
#      dpkg-deb --build . ./pool/d2d-1.0.deb
#      ```
#    - To generate package index and release files for Debian Bullseye (11), Debian Buster (10), and stable distribution, execute the respective commands under `Command to generate package index and release files`.

# 5. **Important Notes**:
#    - Ensure that the current directory (`.`) contains all necessary files, executable scripts, configuration files, and permissions required for the `d2d` CLI tool to function correctly after installation.
#    - Adjust file paths, names, and package versions (`1.0` in this example) according to your project's specifications and versioning guidelines.
#    - Each `dpkg-deb --build` command creates a separate `.deb` package in the specified destination directory (`./pool/`).
#    - Verify the contents and functionality of the generated `.deb` packages (`d2d-1.0.deb`) and release files to ensure they include all required components and perform as expected during installation and usage.
