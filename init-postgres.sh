#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Set default values if variables are not defined in .env file
ORGANIZATION_NAME_DIRTY="${ORGANIZATION_NAME:-icodebible}"
ORGANIZATION_NAME=$(echo "${ORGANIZATION_NAME_DIRTY}" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')

DHIS_PROJECT_NAME_DIRTY="${DHIS_PROJECT_NAME:-icodebible}"
DHIS_PROJECT_NAME=$(echo "${DHIS_PROJECT_NAME_DIRTY}" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')

POSTGRESDB_IMAGE_NAME="postgresdb-${DHIS_PROJECT_NAME}"

POSTGRES_VERSION="${POSTGRES_VERSION:-13}"

# Validate arguments (optional)
# if [[ -z "$ORGANIZATION_NAME" || -z "$POSTGRESDB_IMAGE_NAME" || -z "$POSTGRES_VERSION" ]]; then
#     echo "Usage: $0 ORGANIZATION_NAME POSTGRESDB_IMAGE_NAME POSTGRES_VERSION"
#     exit 1
# fi

POSTGRES_DOCKERFILE="postgres/Dockerfile.postgresdb"

# Build PostgreSQL Docker image
docker build -t $ORGANIZATION_NAME/$POSTGRESDB_IMAGE_NAME:postgres-v$POSTGRES_VERSION -f $POSTGRES_DOCKERFILE .

# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script builds a PostgreSQL Docker image for DHIS2 with versioning and naming conventions.
#
# 2. **Environment Variable Loading**:
#    - Loads environment variables from the `.env` file, excluding commented lines (`#`).
#
# 3. **Fallback to Defaults**:
#    - If `ORGANIZATION_NAME`, `DHIS_PROJECT_NAME`, or `POSTGRES_VERSION` are not set in the `.env` file,
#      defaults (`icodebible`, `icodebible`, `13` respectively) are used.
#
# 4. **Variable Definitions**:
#    - `ORGANIZATION_NAME`: Set to the value from `.env` or defaults to "icodebible". Converted to lowercase and stripped of special characters.
#    - `DHIS_PROJECT_NAME`: Set to the value from `.env` or defaults to "icodebible". Converted to lowercase and stripped of special characters.
#    - `POSTGRESDB_IMAGE_NAME`: Composed using "postgresdb-" prefix with `DHIS_PROJECT_NAME`.
#    - `POSTGRES_VERSION`: Set to the value from `.env` or defaults to "13".
#    - `POSTGRES_DOCKERFILE`: Points to the Dockerfile definition for PostgreSQL (`postgres/Dockerfile.postgresdb`).
#
# 5. **Docker Build Command**:
#    - Uses the `docker build` command to create the Docker image.
#    - `-t $ORGANIZATION_NAME/$POSTGRESDB_IMAGE_NAME:postgres-v$POSTGRES_VERSION`: Tags the Docker image with the specified name and version.
#    - `-f $POSTGRES_DOCKERFILE`: Specifies the Dockerfile to use for the build.
#
# 6. **Important Notes**:
#    - Ensure all necessary variables (e.g., `POSTGRES_DOCKERFILE`) are correctly set in the script.
#    - Verify that the path to the Dockerfile (`POSTGRES_DOCKERFILE`) is accurate and accessible.
#    - Adjust the default values or provide arguments accordingly to match your specific requirements.
#
# 7. **Example Usage**:
#    - To build the PostgreSQL Docker image with custom values, ensure `.env` file is configured appropriately, then run the script: `$0`
#    - Example: `./build-postgres-image.sh`
#
# 8. **Expected Output**:
#    - A Docker image tagged as `<ORGANIZATION_NAME>/<POSTGRESDB_IMAGE_NAME>:postgres-v<POSTGRES_VERSION>` will be created.
