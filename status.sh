#!/bin/bash

# Clear terminal and start afresh
clear

# Disable history for the current session
unset HISTFILE

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# ANSI color codes for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'  # No color

# Function to create a rotating animation of an emoji Earth
rotate_earth_animation() {
    local earth="🌍"
    local delay=0.2
    local rotation=( "⬆️" "↗️" "➡️" "↘️" "⬇️" "↙️" "⬅️" "↖️" )

    while true; do
        for r in "${rotation[@]}"; do
            echo -ne "\r$r $earth"
            sleep $delay
        done
    done
}

# Function to check container status by name pattern
check_container_status() {
    local container_name_pattern="$1"
    docker ps -a --format '{{.ID}} {{.Names}}' | grep "$container_name_pattern" | awk '{print $1}'
}

# Function to monitor container initialization
monitor_container_initialization() {
    local container_id="$1"
    local container_name="$2"
    local container_port="$3"
    local SERVICE_URL="http://localhost:$container_port"

    echo -e "${YELLOW}${BOLD}Monitoring container '${container_id}' initialization${NC}"

    echo ""

    echo -e "${GREEN}${BOLD}Please wait! Preparing your DHIS2 Instance${NC}"

    # Start rotating Earth animation
    rotate_earth_animation &
    ANIMATION_PID=$!

    # Check if the service is accessible
    while ! curl --output /dev/null --silent --head --fail "$SERVICE_URL"; do
        sleep 1
    done

    # Stop the rotating animation
    kill $ANIMATION_PID
    wait $ANIMATION_PID 2>/dev/null

    echo ""

    # Display service accessibility message with bold link
    echo -e "${NC}${YELLOW}${BOLD}Service is accessible at: ${CYAN}${BOLD} ${SERVICE_URL}${NC}"

    echo ""

    # Display welcoming message and DHIS2 instance information
    echo -e "${GREEN}${BOLD}Welcome to DHIS2 instance!${NC}"
    echo -e "${GREEN}---------------------------------------------------------------${NC}"
    echo -e "${GREEN}DHIS2 URL: ${CYAN}${BOLD}${SERVICE_URL}${NC}"
    echo -e "${GREEN}DHIS2 Instance Information:${NC}"
    echo -e "${GREEN}${BOLD} - Organization: ${ORGANIZATION_NAME}"
    echo -e " - DHIS Project: ${DHIS_PROJECT_NAME}"
    echo -e " - DHIS Version: ${DHIS_VERSION}${NC}"
    echo -e "${GREEN}---------------------------------------------------------------${NC}"
    echo ""

    # Print extended line separator
    echo "------------------------------------------------------------------"
}

# Main function
main() {
    # Get the container ID for the DHIS2 instance
    container_id=$(check_container_status "app_web_${ORGANIZATION_NAME}_${DHIS_PROJECT_NAME}_dhis_v${DHIS_VERSION}")

    # Check if the container ID is retrieved
    if [ -n "$container_id" ]; then
        container_name=$(docker ps -a --format '{{.ID}} {{.Names}}' | grep "$container_id" | awk '{print $2}')
        container_port=$(docker port "$container_id" 8080 | cut -d ':' -f 2)

        # Print extended line separator
        echo "------------------------------------------------------------------"

        # Display container information with formatting
        echo -e "${BOLD}CONTAINER NAME: ${YELLOW}${BOLD}'${container_name^^}'${NC}"
        echo -e "${BOLD}CONTAINER PORT: ${YELLOW}${BOLD}'${container_port^^}'${NC}"
        echo -e "${BOLD}POSTGRES HOST MACHINE PORT: ${YELLOW}${BOLD}'${POSTGRES_HOST_PORT^^}'${NC}"

        echo ""

        # Inform about container status
        echo -e "${YELLOW}${BOLD}Container [${container_id}] is running.${NC}"

        echo ""

        # Monitor container initialization
        monitor_container_initialization "$container_id" "$container_name" "$container_port"

    else
        # Inform when container matching the specified name pattern is not found
        echo -e "${RED}Container with the specified name pattern is not found.${NC}"
    fi
}

# Run main function
main

# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script monitors the initialization of a Docker container and verifies the availability of a service inside the container through a HTTP request. It provides feedback when the container completes initialization, including a welcoming message and DHIS2 instance information.
#
# 2. **Functions**:
#    - **Function: `check_container_status`**:
#      - **Usage**: `check_container_status CONTAINER_NAME_PATTERN`
#      - **Description**: Checks the status of a Docker container by searching for a specific name pattern (`CONTAINER_NAME_PATTERN`). Returns the container ID if found.
#    
#    - **Function: `monitor_container_initialization`**:
#      - **Usage**: `monitor_container_initialization CONTAINER_ID CONTAINER_NAME CONTAINER_PORT`
#      - **Description**: Monitors the initialization progress of a Docker container (`CONTAINER_ID`). Displays a rotating animation during initialization and checks service availability until reachable. Prints DHIS2 instance information upon successful initialization.
#
#    - **Function: `main`**:
#      - **Description**: Main function that initiates the monitoring process for a DHIS2 Docker container dynamically fetched based on specified naming conventions. Checks if the container exists and is running, then calls `monitor_container_initialization` to monitor its initialization.
#
# 3. **Environment Variables**:
#    - Loads environment variables from the `.env` file for configuration, including Docker container names (`ORGANIZATION_NAME`, `DHIS_PROJECT_NAME`, `DHIS_VERSION`).
#
# 4. **Usage**:
#    - Ensure Docker is running and execute the script in your terminal:
#      ```bash
#      ./monitor_container.sh
#      ```
#
# 5. **Expected Output**:
#    - Dynamically identifies and monitors the initialization status of a Docker container based on specified naming conventions. Upon successful initialization and service availability, it displays a welcoming message with the DHIS2 instance information, including its URL, organization name, project name, and version.
