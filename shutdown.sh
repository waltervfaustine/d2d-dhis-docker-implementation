#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# DOCUMENTATION:
# Loads environment variables from the .env file.
# - 'grep -v '^#'' filters out comment lines.
# - 'xargs' converts the output to arguments for the 'export' command.

# Get the directory where the docker-compose.yml file is located
DOCKER_COMPOSE_DIR=$(dirname "$(realpath docker-compose.yml)")

# DOCUMENTATION:
# Retrieves the directory path of the 'docker-compose.yml' file.
# - 'realpath docker-compose.yml' returns the absolute path of the file.
# - 'dirname' extracts the directory part of the path.

# Get the last folder name in the path and convert to lowercase
LAST_FOLDER_NAME=$(basename "$DOCKER_COMPOSE_DIR" | tr '[:upper:]' '[:lower:]')

# DOCUMENTATION:
# Retrieves the last folder name in the directory path and converts it to lowercase.
# - 'basename' extracts the last component of the directory path.
# - 'tr '[:upper:]' '[:lower:]'' converts uppercase letters to lowercase.

# Stop and remove specific containers matching naming patterns
docker ps -a --format '{{.ID}} {{.Names}}' | grep "app_web_${ORGANIZATION_NAME}_${DHIS_PROJECT_NAME}_dhis_v${DHIS_VERSION}" | awk '{print $1}' | xargs -r docker stop | xargs -r docker rm
docker ps -a --format '{{.ID}} {{.Names}}' | grep "db_postgres_${ORGANIZATION_NAME}_${DHIS_PROJECT_NAME}_v${POSTGRES_VERSION}" | awk '{print $1}' | xargs -r docker stop | xargs -r docker rm

# DOCUMENTATION:
# Stops and removes specific Docker containers with names matching the specified patterns.
# - 'docker ps -a --format' lists container IDs and names.
# - 'grep' filters containers based on the name patterns.
# - 'awk' extracts the container IDs.
# - 'xargs -r docker stop' stops the matching containers.
# - 'xargs -r docker rm' removes the stopped containers.

# Remove images matching ${ORGANIZATION_NAME}/postgresdb-${DHIS_PROJECT_NAME}:postgres-v${POSTGRES_VERSION}
docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep "${ORGANIZATION_NAME}/postgresdb-${DHIS_PROJECT_NAME}:postgres-v${POSTGRES_VERSION}")

# DOCUMENTATION:
# Removes Docker images matching the specified pattern.
# - 'docker images --format' lists images in the format 'repository:tag'.
# - 'grep' filters images based on '${ORGANIZATION_NAME}/postgresdb-${DHIS_PROJECT_NAME}:postgres-v${POSTGRES_VERSION}' pattern.
# - 'docker rmi' removes the images that match the pattern.

# Remove images matching ${ORGANIZATION_NAME}/${DHIS_PROJECT_NAME}-tomcat-dhis:tomcat-dhis-${DHIS_VERSION}
docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep "${ORGANIZATION_NAME}/${DHIS_PROJECT_NAME}-tomcat-dhis:tomcat-dhis-${DHIS_VERSION}")

# DOCUMENTATION:
# Removes Docker images matching the specified pattern.
# - 'docker images --format' lists images in the format 'repository:tag'.
# - 'grep' filters images based on '${ORGANIZATION_NAME}/${DHIS_PROJECT_NAME}-tomcat-dhis:tomcat-dhis-${DHIS_VERSION}' pattern.
# - 'docker rmi' removes the images that match the pattern.

# Remove specific volumes
docker volume rm ${LAST_FOLDER_NAME}_${DHIS_PROJECT_NAME}_db_data ${LAST_FOLDER_NAME}_${DHIS_PROJECT_NAME}_dhis_home

# DOCUMENTATION:
# Removes specific Docker volumes.
# - 'docker volume rm' removes the volumes identified by their names (${LAST_FOLDER_NAME}_${DHIS_PROJECT_NAME}_db_data, ${LAST_FOLDER_NAME}_${DHIS_PROJECT_NAME}_dhis_home).

# Remove specific network
docker network rm ${DHIS_PROJECT_NAME}-dhis-network

# DOCUMENTATION:
# Removes a specific Docker network.
# - 'docker network rm' removes the network identified by its name (${DHIS_PROJECT_NAME}-dhis-network).

# Remove all networks not used by at least one container
docker network prune -f

# DOCUMENTATION:
# Removes all Docker networks that are not used by at least one container.
# - 'docker network prune -f' performs a forced prune to remove unused networks.

# Clean up unused Docker images
docker image prune -f

# DOCUMENTATION:
# Cleans up all unused Docker images.
# - 'docker image prune -f' performs a forced prune to remove unused images.
