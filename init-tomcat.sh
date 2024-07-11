#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Function to determine the JDK and Tomcat versions based on DHIS2 version
# This function takes a single argument (DHIS2 version) and sets the JDK_VERSION
# and TOMCAT_VERSION variables accordingly.
determine_versions() {
    local dhis2_version=$1

    if [[ $dhis2_version -ge 41 ]]; then
        JDK_VERSION="17"
        TOMCAT_VERSION="9.0.65-jdk17"
    elif [[ $dhis2_version -ge 40 ]]; then
        JDK_VERSION="17"
        TOMCAT_VERSION="9.0.65-jdk17"
    elif [[ $dhis2_version -ge 38 ]]; then
        JDK_VERSION="11"
        TOMCAT_VERSION="9.0.65-jdk11"
    elif [[ $dhis2_version -ge 35 ]]; then
        JDK_VERSION="11"
        TOMCAT_VERSION="9.0.65-jdk11"
    else
        JDK_VERSION="8"
        TOMCAT_VERSION="9.0.65-jdk8"
    fi
}

# Source the .env file to load environment variables
if [ -f .env ]; then
    source .env
fi

# Set default value for DHIS_WAR_URL if not defined in .env
# DHIS_WAR_URL=${DHIS_WAR_URL:-"https://releases.dhis2.org/42/dhis2-stable-latest.war"}

# Extract DHIS2 version from the URL
# DHIS_VERSION=$(echo $DHIS_WAR_URL | grep -oP '(?<=releases.dhis2.org/)\d+(\.\d+)?(?=/)')


# Extract minor version from DHIS2 version (dropping major version)
MINOR_VERSION=$(echo $DHIS_VERSION | cut -d'.' -f2)

# Determine the appropriate JDK and Tomcat versions based on the extracted minor version
determine_versions $MINOR_VERSION

# Echo the extracted DHIS2 version and determined Tomcat version
# echo "DHIS2 Version: $DHIS_VERSION_STANDARD_FULL"
echo "DHIS2 Version: $DHIS_VERSION"
echo "Tomcat Version: $TOMCAT_VERSION"

# Append DHIS_VERSION to .env file if not already present
if ! grep -q "^DHIS_VERSION=" .env; then
    echo "DHIS_VERSION=$DHIS_VERSION" >> .env
else
    sed -i "s|^DHIS_VERSION=.*|DHIS_VERSION=$DHIS_VERSION|" .env
fi


# DOCUMENTATION:
# 1. **Function to Determine JDK and Tomcat Versions**: The `determine_versions` function sets the JDK and Tomcat versions based on the DHIS2 version extracted from the provided URL. It compares the minor version to determine compatibility.
# 2. **Environment Variable Loading**: The script sources the `.env` file to load environment variables, allowing customization of DHIS_WAR_URL and other configurations.
# 3. **Default DHIS2 WAR URL**: If not specified in `.env`, the script defaults to downloading the latest DHIS2 WAR file from `https://releases.dhis2.org/2.41/dhis2-stable-latest.war`.
# 4. **DHIS2 Version Extraction**: It extracts the DHIS2 version from the URL and derives the minor version by dropping the major version component.
# 5. **Version-Based Configuration**: Based on the minor version extracted, the script determines and outputs the compatible JDK and Tomcat versions for building the Docker image.
# 6. **Execution**: Ensure this script is executable (`chmod +x script.sh`) and used as intended for setting up a Docker environment tailored for DHIS2 deployments.

# Set default values if variables are not defined in .env file
ORGANIZATION_NAME_DIRTY="${ORGANIZATION_NAME:-icodebible}"
ORGANIZATION_NAME=$(echo "${ORGANIZATION_NAME_DIRTY}" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')

DHIS_PROJECT_NAME_DIRTY="${DHIS_PROJECT_NAME:-cainam}"
DHIS_PROJECT_NAME=$(echo "${DHIS_PROJECT_NAME_DIRTY}" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')

DHIS_TOMCAT_IMAGE_NAME="${DHIS_PROJECT_NAME}-tomcat-dhis"

DHIS_VERSION="${DHIS_VERSION:-2.41}"

# Validate arguments (optional)
# if [[ -z "$ORGANIZATION_NAME" || -z "$DHIS_TOMCAT_IMAGE_NAME" || -z "$DHIS_VERSION" ]]; then
#     echo "Usage: $0 ORGANIZATION_NAME DHIS_TOMCAT_IMAGE_NAME DHIS_VERSION"
#     exit 1
# fi

# Set Dockerfile path
TOMCAT_DOCKERFILE="tomcat/Dockerfile.tomcat"

DEBIAN_FRONTEND=noninteractive

CATALINA_HOME=/usr/local/tomcat

# Build the Tomcat-DHIS2 Docker image
docker build \
    --build-arg DEBIAN_FRONTEND=$DEBIAN_FRONTEND \
    --build-arg TZ=$TZ \
    --build-arg CATALINA_HOME=$CATALINA_HOME \
    --build-arg JDK_JAVA_OPTIONS=$JDK_JAVA_OPTIONS \
    --build-arg ORGANIZATION_NAME=$ORGANIZATION_NAME \
    --build-arg DHIS_TOMCAT_IMAGE_NAME=$DHIS_TOMCAT_IMAGE_NAME \
    --build-arg DHIS_VERSION=$DHIS_VERSION \
    --build-arg JDK_VERSION=$JDK_VERSION \
    --build-arg TOMCAT_VERSION=$TOMCAT_VERSION \
    --build-arg DHIS_WAR_URL=$DHIS_WAR_URL \
    --build-arg DHIS_HOME=$DHIS_HOME \
    -t $ORGANIZATION_NAME/$DHIS_TOMCAT_IMAGE_NAME:tomcat-dhis-$DHIS_VERSION \
    -f $TOMCAT_DOCKERFILE .

# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script builds a Tomcat-DHIS2 Docker image with versioning and naming conventions.
#
# 2. **Environment Variable Loading**:
#    - Loads environment variables from the `.env` file, ignoring commented lines (`#`).
#
# 3. **Fallback to Defaults**:
#    - If `ORGANIZATION_NAME`, `DHIS_PROJECT_NAME`, `DHIS_TOMCAT_IMAGE_NAME`, or `DHIS_VERSION` are not set in the `.env` file,
#      defaults (`icodebible`, `cainam`, `cainam-tomcat-dhis`, `2.41` respectively) are used.
#
# 4. **Variable Definitions**:
#    - `ORGANIZATION_NAME`: Set to the value from `.env` or defaults to "icodebible". Converted to lowercase and stripped of special characters.
#    - `DHIS_PROJECT_NAME`: Set to the value from `.env` or defaults to "cainam". Converted to lowercase and stripped of special characters.
#    - `DHIS_TOMCAT_IMAGE_NAME`: Composed using `DHIS_PROJECT_NAME`. Converted to lowercase and stripped of special characters.
#    - `DHIS_VERSION`: Set to the value from `.env` or defaults to "2.41".
#
# 5. **Docker Build Command**:
#    - Uses the `docker build` command to create the Docker image for Tomcat-DHIS2.
#    - `--build-arg` options pass build arguments like `DHIS_WAR_URL`, `DEBIAN_FRONTEND`, `TZ`, `DHIS_HOME`, `CATALINA_HOME`, `JDK_JAVA_OPTIONS`.
#    - Additional `--build-arg` options pass `ORGANIZATION_NAME`, `DHIS_TOMCAT_IMAGE_NAME`, and `DHIS_VERSION` as build arguments.
#    - `-t $ORGANIZATION_NAME/$DHIS_TOMCAT_IMAGE_NAME:tomcat-dhis-$DHIS_VERSION`: Tags the Docker image with the specified name and version.
#    - `-f $TOMCAT_DOCKERFILE`: Specifies the Dockerfile to use for the build.
#
# 6. **Important Notes**:
#    - Ensure all necessary variables (e.g., `DHIS_WAR_URL`, `DEBIAN_FRONTEND`, `TZ`, `DHIS_HOME`, `CATALINA_HOME`, `JDK_JAVA_OPTIONS`) are correctly set in the `.env` file before running the script.
#    - Verify that the path to the Dockerfile (`TOMCAT_DOCKERFILE`) is accurate and accessible.
#    - Adjust the default values or provide arguments accordingly to match your specific requirements.
#
# 7. **Example Usage**:
#    - To build the Docker image with custom values, ensure `.env` file is configured appropriately, then run the script: `$0`
#    - Example: `./build-tomcat-image.sh`
#
# 8. **Expected Output**:
#    - A Docker image tagged as `<ORGANIZATION_NAME>/<DHIS_TOMCAT_IMAGE_NAME>:tomcat-dhis-<DHIS_VERSION>` will be created.
