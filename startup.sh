#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# DOCUMENTATION:
# 1. **Load Environment Variables**:
#    - Loads environment variables defined in the .env file into the current shell session.
#    - Ensures environment variables like `DHIS_PROJECT_NAME`, `ORGANIZATION_NAME`, and others are available for use.


# Initialize PostgreSQL
./init-postgres.sh

# Initialize Tomcat
./init-tomcat.sh


# DOCUMENTATION:
# 2. **Initialize Services**:
#    - Runs `init-postgres.sh` and `init-tomcat.sh` scripts to set up PostgreSQL and Tomcat respectively.

# Ensure docker-compose.yml exists
touch docker-compose.yml

Check if the network exists
if ! docker network inspect ${DHIS_PROJECT_NAME}-dhis-network &>/dev/null; then
    # Create the network
    docker network create ${DHIS_PROJECT_NAME}-dhis-network
    echo "Created network: ${DHIS_PROJECT_NAME}-dhis-network"
else
    echo "Network ${DHIS_PROJECT_NAME}-dhis-network already exists."
fi

# DOCUMENTATION:
# 3. **Network Creation**:
#    - Checks if the network `${DHIS_PROJECT_NAME}-dhis-network` exists; creates it if not.
#    - Provides network isolation for services defined in the `docker-compose.yml` file.
#    - Ensures services can communicate securely within the Docker environment.

# Substitute environment variables in docker-compose.yml template and generate docker-compose.yml
envsubst < ./template/docker-compose.yml.template > docker-compose.yml

# DOCUMENTATION:
# 4. **Generate docker-compose.yml**:
#    - Uses `envsubst` to substitute environment variables in `./template/docker-compose.yml.template` and generate `docker-compose.yml`.

# Stop and remove all running containers defined in the Docker Compose file
docker-compose down

# DOCUMENTATION:
# 5. **docker-compose down**:
#    - Stops and removes all containers defined in the Docker Compose file.
#    - Stops all running containers specified in the `docker-compose.yml` file.
#    - Removes the containers, networks, and volumes associated with the services.
#    - Use this command to clean up resources and stop services.

# Build images, recreate containers if necessary, and start all containers in detached mode
docker-compose up --force-recreate --build -d


# DOCUMENTATION:
# 6. **docker-compose up --build -d**:
#    - Builds images if changes are detected, recreates containers if necessary, and starts all containers in detached mode.
#    - `--build`: Builds images before starting containers.
#    - `-d`: Detached mode - runs containers in the background.
#    - Starts all services defined in the `docker-compose.yml` file.
#    - Use this command to apply changes and start services after modifying the configuration or code.

# Provide status information after deployment
./status.sh

# DOCUMENTATION:
# 7. **Status Check**:
#    - Executes `bash status.sh` to provide status information after deploying Docker Compose services.
#    - Helps monitor and verify the deployment status of containers and services.

# DOCUMENTATION SUMMARY:
# - This script automates the deployment process for a Docker Compose setup involving PostgreSQL and Tomcat for DHIS2.
# - It initializes necessary services, creates a Docker network if not existing, generates the `docker-compose.yml` file with environment variable substitutions, and manages container lifecycle.
# - Use the documented commands to understand and manage the deployment effectively.
