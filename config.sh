#!/bin/bash

## Step 1: Create the .env file
# This script creates a `.env` file to store environment variables for Docker configurations and other scripts.

bash shutdown.sh

touch .env

# Function to generate a random port number between 49152 and 65535
generate_random_port() {
    shuf -i 49152-65535 -n 1
}

# Function to check if a port is available
port_is_free() {
    local port=$1
    if [[ $(uname) == "Darwin" ]]; then
        ! lsof -i :$port >/dev/null
    else
        ! netstat -ant | grep -q ":$port\b"
    fi
}

# Find a random free port
find_random_free_port() {
    local port
    port=$(generate_random_port)
    while ! port_is_free "$port"; do
        port=$(generate_random_port)
    done
    echo "$port"
}

# Function to extract value from new_env_values based on key
get_env_value() {
    local key="$1"
    local new_env_values=("${@:2}")

    for env_var in "${new_env_values[@]}"; do
        # Split the environment variable into key and value
        local current_key="${env_var%%=*}"
        local current_value="${env_var#*=}"

        # Check if the current key matches the desired key
        if [[ "$current_key" == "$key" ]]; then
            echo "$current_value"
            return 0
        fi
    done

    # If key not found, return an empty string
    echo ""
}

# Function to prompt the user for a value with a default option
prompt_for_value() {
    local var_name="$1"
    local var_default="$2"
    local var_value

    # Loop until a valid input is provided
    while true; do
        read -p "$(tput bold)Enter value for $(tput setaf 4)$var_name$(tput sgr0) $(tput bold)(default: $var_default): $(tput sgr0)" var_value

        # If no value is provided, use the default
        if [ -z "$var_value" ]; then
            var_value="$var_default"
        fi

        # Validate the input (if needed)
        # Example: Ensure the input is not empty if it's mandatory
        if [ -z "$var_value" ]; then
            echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Value cannot be empty. Please provide a value."
        else
            # Return the formatted variable assignment
            echo "$var_name=$var_value"
            break
        fi
    done
}

# Function to display a selected value
get_selected_value() {
    local var_name="$1"
    local var_value="$2"

    echo "$var_name=$var_value"
}


# Introduction message and documentation
echo ""
echo "$(tput bold)$(tput setaf 4)Welcome to DHIS2 and PostgreSQL Configuration Setup!$(tput sgr0)"
echo "=========================================================="
echo "This script guides you through setting up environment variables"
echo "for $(tput bold)$(tput setaf 6)DHIS2$(tput sgr0) and $(tput bold)$(tput setaf 6)PostgreSQL$(tput sgr0)."
echo ""
echo "This script sets up environment variables for DHIS2 and PostgreSQL."
echo "User input is prompted for each variable, with defaults provided."
echo "DHIS2 version and WAR file URL are selected based on user input."

# Load .env file
if [ -f ./template/.env.template ]; then
  # export $(grep -v '^#' .env.template | xargs)
  export $(grep -v '^#' ./template/.env.template | xargs)
else
  echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) ./template/.env.template file not found!"
  exit 1
fi

# Present the user with a list of DHIS2 versions
echo ""
echo "$(tput bold)Please select a DHIS2 version by entering the corresponding number:$(tput sgr0)"
echo ""
echo "1. $(tput bold)DHIS Version $(tput setaf 3)41$(tput sgr0)"
echo "2. $(tput bold)DHIS Version $(tput setaf 3)40$(tput sgr0)"
echo "3. $(tput bold)DHIS Version $(tput setaf 3)2.39$(tput sgr0)"
echo "4. $(tput bold)DHIS Version $(tput setaf 3)2.38$(tput sgr0)"
echo "5. $(tput bold)DHIS Version $(tput setaf 3)2.37$(tput sgr0)"
echo "6. $(tput bold)DHIS Version $(tput setaf 3)2.36$(tput sgr0)"
echo "7. $(tput bold)DHIS Version $(tput setaf 3)2.35$(tput sgr0)"
echo "8. $(tput bold)DHIS Version $(tput setaf 3)2.34$(tput sgr0)"
echo "9. $(tput bold)DHIS Version $(tput setaf 3)2.33$(tput sgr0)"
echo "10. $(tput bold)DHIS Version $(tput setaf 3)2.32$(tput sgr0)"
echo ""

# read -p "Enter the number: " dhis_version_choice
read -p "$(tput bold)Please enter the number corresponding to your choice: $(tput sgr0)" dhis_version_choice

# Map the user's choice to the actual DHIS2 version
case "$dhis_version_choice" in
  1) DHIS_VERSION="41";;
  2) DHIS_VERSION="40";;
  3) DHIS_VERSION="2.39";;
  4) DHIS_VERSION="2.38";;
  5) DHIS_VERSION="2.37";;
  6) DHIS_VERSION="2.36";;
  7) DHIS_VERSION="2.35";;
  8) DHIS_VERSION="2.34";;
  9) DHIS_VERSION="2.33";;
  10) DHIS_VERSION="2.32";;
  *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
esac

# Depending on the chosen DHIS2 version, present the user with a list of WAR file URLs
case "$DHIS_VERSION" in
  "41")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo ""
    echo "1. https://releases.dhis2.org/41/dhis2-stable-41.0.1.war"
    echo "2. https://releases.dhis2.org/41/dhis2-stable-latest.war"
    echo "3. https://releases.dhis2.org/41/dhis2-stable-41.0.0.war"
    echo ""
    # read -p "Enter the number: " dhis_war_choice
    read -p "$(tput bold)Please enter the number corresponding to your choice: $(tput sgr0)" dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/41/dhis2-stable-41.0.1.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/41/dhis2-stable-latest.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/41/dhis2-stable-41.0.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "40")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/40/dhis2-stable-40.4.1.war"
    echo "2. https://releases.dhis2.org/40/dhis2-stable-latest.war"
    echo "3. https://releases.dhis2.org/40/dhis2-stable-40.4.0.war"
    echo "4. https://releases.dhis2.org/40/dhis2-stable-40.3.2.war"
    echo "5. https://releases.dhis2.org/40/dhis2-stable-40.3.1.war"
    echo "6. https://releases.dhis2.org/40/dhis2-stable-40.3.0.war"
    echo "7. https://releases.dhis2.org/40/dhis2-stable-40.2.2.war"
    echo "8. https://releases.dhis2.org/40/dhis2-stable-40.2.1.war"
    echo "9. https://releases.dhis2.org/40/dhis2-stable-40.2.0.war"
    echo "10. https://releases.dhis2.org/40/dhis2-stable-40.1.0.war"
    echo "11. https://releases.dhis2.org/40/dhis2-stable-40.0.1.war"
    echo "12. https://releases.dhis2.org/40/dhis2-stable-40.0.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.4.1.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-latest.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.4.0.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.3.2.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.3.1.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.3.0.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.2.2.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.2.1.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.2.0.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.1.0.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.0.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/40/dhis2-stable-40.0.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.39")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.39/dhis2-stable-latest.war"
    echo "2. https://releases.dhis2.org/2.39/dhis2-stable-2.39.5.war"
    echo "3. https://releases.dhis2.org/2.39/dhis2-stable-2.39.4.1.war"
    echo "4. https://releases.dhis2.org/2.39/dhis2-stable-2.39.4.war"
    echo "5. https://releases.dhis2.org/2.39/dhis2-stable-2.39.3.1.war"
    echo "6. https://releases.dhis2.org/2.39/dhis2-stable-2.39.3.war"
    echo "7. https://releases.dhis2.org/2.39/dhis2-stable-2.39.2.1.war"
    echo "8. https://releases.dhis2.org/2.39/dhis2-stable-2.39.2.war"
    echo "9. https://releases.dhis2.org/2.39/dhis2-stable-2.39.1.2.war"
    echo "10. https://releases.dhis2.org/2.39/dhis2-stable-2.39.1.1.war"
    echo "11. https://releases.dhis2.org/2.39/dhis2-stable-2.39.1.war"
    echo "12. https://releases.dhis2.org/2.39/dhis2-stable-2.39.0.0.war"
    echo "13. https://releases.dhis2.org/2.39/dhis2-stable-2.39.0.1.war"
    echo "14. https://releases.dhis2.org/2.39/dhis2-stable-2.39.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-latest.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.5.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.4.1.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.4.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.3.1.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.3.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.2.1.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.2.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.1.2.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.1.1.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.0.0.war";;
      13) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.0.1.war";;
      14) DHIS_WAR_URL="https://releases.dhis2.org/2.39/dhis2-stable-2.39.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.38")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.38/dhis2-stable-latest.war"
    echo "2. https://releases.dhis2.org/2.38/dhis2-stable-2.38.7.war"
    echo "3. https://releases.dhis2.org/2.38/dhis2-stable-2.38.6.war"
    echo "4. https://releases.dhis2.org/2.38/dhis2-stable-2.38.5.1.war"
    echo "5. https://releases.dhis2.org/2.38/dhis2-stable-2.38.5.war"
    echo "6. https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.3.war"
    echo "7. https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.2.war"
    echo "8. https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.0.war"
    echo "9. https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.1.war"
    echo "10. https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.war"
    echo "11. https://releases.dhis2.org/2.38/dhis2-stable-2.38.3.1.war"
    echo "12. https://releases.dhis2.org/2.38/dhis2-stable-2.38.3.war"
    echo "13. https://releases.dhis2.org/2.38/dhis2-stable-2.38.2.0.war"
    echo "14. https://releases.dhis2.org/2.38/dhis2-stable-2.38.1.0.war"
    echo "15. https://releases.dhis2.org/2.38/dhis2-stable-2.38.2.1.war"
    echo "16. https://releases.dhis2.org/2.38/dhis2-stable-2.38.2.war"
    echo "17. https://releases.dhis2.org/2.38/dhis2-stable-2.38.1.1.war"
    echo "18. https://releases.dhis2.org/2.38/dhis2-stable-2.38.1.war"
    echo "19. https://releases.dhis2.org/2.38/dhis2-stable-2.38.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-latest.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.7.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.6.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.5.1.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.5.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.3.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.2.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.0.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.1.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.4.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.3.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.3.war";;
      13) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.2.0.war";;
      14) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.1.0.war";;
      15) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.2.1.war";;
      16) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.2.war";;
      17) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.1.1.war";;
      18) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.1.war";;
      19) DHIS_WAR_URL="https://releases.dhis2.org/2.38/dhis2-stable-2.38.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.37")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.37/dhis2-stable-2.37-eos.war"
    echo "2. https://releases.dhis2.org/2.37/dhis2-stable-latest.war"
    echo "3. https://releases.dhis2.org/2.37/dhis2-stable-2.37.10.war"
    echo "4. https://releases.dhis2.org/2.37/dhis2-stable-2.37.9.1.war"
    echo "5. https://releases.dhis2.org/2.37/dhis2-stable-2.37.9.war"
    echo "6. https://releases.dhis2.org/2.37/dhis2-stable-2.37.8.0.war"
    echo "7. https://releases.dhis2.org/2.37/dhis2-stable-2.37.7.0.war"
    echo "8. https://releases.dhis2.org/2.37/dhis2-stable-2.37.6.0.war"
    echo "9. https://releases.dhis2.org/2.37/dhis2-stable-2.37.8.1.war"
    echo "10. https://releases.dhis2.org/2.37/dhis2-stable-2.37.8.war"
    echo "11. https://releases.dhis2.org/2.37/dhis2-stable-2.37.7.1.war"
    echo "12. https://releases.dhis2.org/2.37/dhis2-stable-2.37.7.war"
    echo "13. https://releases.dhis2.org/2.37/dhis2-stable-2.37.6.1.war"
    echo "14. https://releases.dhis2.org/2.37/dhis2-stable-2.37.6.war"
    echo "15. https://releases.dhis2.org/2.37/dhis2-stable-2.37.5.war"
    echo "16. https://releases.dhis2.org/2.37/dhis2-stable-2.37.4.war"
    echo "17. https://releases.dhis2.org/2.37/dhis2-stable-2.37.3.war"
    echo "18. https://releases.dhis2.org/2.37/dhis2-stable-2.37.2.war"
    echo "19. https://releases.dhis2.org/2.37/dhis2-stable-2.37.1.war"
    echo "20. https://releases.dhis2.org/2.37/dhis2-stable-2.37.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-latest.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.10.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.9.1.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.9.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.8.0.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.7.0.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.6.0.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.8.1.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.8.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.7.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.7.war";;
      13) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.6.1.war";;
      14) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.6.war";;
      15) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.5.war";;
      16) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.4.war";;
      17) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.3.war";;
      18) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.2.war";;
      19) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.1.war";;
      20) DHIS_WAR_URL="https://releases.dhis2.org/2.37/dhis2-stable-2.37.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.36")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.36/dhis2-stable-2.36-eos.war"
    echo "2. https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.war"
    echo "3. https://releases.dhis2.org/2.36/dhis2-stable-latest.war"
    echo "4. https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.2.war"
    echo "5. https://releases.dhis2.org/2.36/dhis2-stable-2.36.12.0.war"
    echo "6. https://releases.dhis2.org/2.36/dhis2-stable-2.36.10.0.war"
    echo "7. https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.0.war"
    echo "8. https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.1.war"
    echo "9. https://releases.dhis2.org/2.36/dhis2-stable-2.36.12.1.war"
    echo "10. https://releases.dhis2.org/2.36/dhis2-stable-2.36.12.war"
    echo "11. https://releases.dhis2.org/2.36/dhis2-stable-2.36.11.1.war"
    echo "12. https://releases.dhis2.org/2.36/dhis2-stable-2.36.10.1.war"
    echo "13. https://releases.dhis2.org/2.36/dhis2-stable-2.36.10.war"
    echo "14. https://releases.dhis2.org/2.36/dhis2-stable-2.36.9.war"
    echo "15. https://releases.dhis2.org/2.36/dhis2-stable-2.36.8.war"
    echo "16. https://releases.dhis2.org/2.36/dhis2-stable-2.36.7.war"
    echo "17. https://releases.dhis2.org/2.36/dhis2-stable-2.36.6.war"
    echo "18. https://releases.dhis2.org/2.36/dhis2-stable-2.36.5.war"
    echo "19. https://releases.dhis2.org/2.36/dhis2-stable-2.36.4.war"
    echo "20. https://releases.dhis2.org/2.36/dhis2-stable-2.36.4-EMBARGOED.war"
    echo "21. https://releases.dhis2.org/2.36/dhis2-stable-2.36.3.war"
    echo "22. https://releases.dhis2.org/2.36/dhis2-stable-2.36.2.war"
    echo "23. https://releases.dhis2.org/2.36/dhis2-stable-2.36.1.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-latest.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.2.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.12.0.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.10.0.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.0.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.13.1.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.12.1.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.12.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.11.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.10.1.war";;
      13) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.10.war";;
      14) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.9.war";;
      15) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.8.war";;
      16) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.7.war";;
      17) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.6.war";;
      18) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.5.war";;
      19) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.4.war";;
      20) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.4-EMBARGOED.war";;
      21) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.3.war";;
      22) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.2.war";;
      23) DHIS_WAR_URL="https://releases.dhis2.org/2.36/dhis2-stable-2.36.1.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.35")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.35/dhis2-stable-2.35-eos.war"
    echo "2. https://releases.dhis2.org/2.35/dhis2-stable-latest.war"
    echo "3. https://releases.dhis2.org/2.35/dhis2-stable-2.35.14.war"
    echo "4. https://releases.dhis2.org/2.35/dhis2-stable-2.35.13.war"
    echo "5. https://releases.dhis2.org/2.35/dhis2-stable-2.35.12.war"
    echo "6. https://releases.dhis2.org/2.35/dhis2-stable-2.35.11.war"
    echo "7. https://releases.dhis2.org/2.35/dhis2-stable-2.35.10.war"
    echo "8. https://releases.dhis2.org/2.35/dhis2-stable-2.35.9.war"
    echo "9. https://releases.dhis2.org/2.35/dhis2-stable-2.35.8.war"
    echo "10. https://releases.dhis2.org/2.35/dhis2-stable-2.35.7.war"
    echo "11. https://releases.dhis2.org/2.35/dhis2-stable-2.35.8-EMBARGOED.war"
    echo "12. https://releases.dhis2.org/2.35/dhis2-stable-2.35.7-EMBARGOED.war"
    echo "13. https://releases.dhis2.org/2.35/dhis2-stable-2.35.6.war"
    echo "14. https://releases.dhis2.org/2.35/dhis2-stable-2.35.4.war"
    echo "15. https://releases.dhis2.org/2.35/dhis2-stable-2.35.5.war"
    echo "16. https://releases.dhis2.org/2.35/dhis2-stable-2.35.3.war"
    echo "17. https://releases.dhis2.org/2.35/dhis2-stable-2.35.2.war"
    echo "18. https://releases.dhis2.org/2.35/dhis2-stable-2.35.1.war"
    echo "19. https://releases.dhis2.org/2.35/dhis2-stable-2.35.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-latest.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.14.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.13.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.12.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.11.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.10.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.9.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.8.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.7.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.8-EMBARGOED.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.7-EMBARGOED.war";;
      13) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.6.war";;
      14) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.4.war";;
      15) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.5.war";;
      16) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.3.war";;
      17) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.2.war";;
      18) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.1.war";;
      19) DHIS_WAR_URL="https://releases.dhis2.org/2.35/dhis2-stable-2.35.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.34")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.34/dhis2-stable-2.34-eos.war"
    echo "2. https://releases.dhis2.org/2.34/dhis2-stable-latest.war"
    echo "3. https://releases.dhis2.org/2.34/dhis2-stable-2.34.9.war"
    echo "4. https://releases.dhis2.org/2.34/dhis2-stable-2.34.8.war"
    echo "5. https://releases.dhis2.org/2.34/dhis2-stable-2.34.7.war"
    echo "6. https://releases.dhis2.org/2.34/dhis2-stable-2.34.7-EMBARGOED.war"
    echo "7. https://releases.dhis2.org/2.34/dhis2-stable-2.34.6.war"
    echo "8. https://releases.dhis2.org/2.34/dhis2-stable-2.34.5.war"
    echo "9. https://releases.dhis2.org/2.34/dhis2-stable-2.34.3.war"
    echo "10. https://releases.dhis2.org/2.34/dhis2-stable-2.34.2.war"
    echo "11. https://releases.dhis2.org/2.34/dhis2-stable-2.34.1.war"
    echo "12. https://releases.dhis2.org/2.34/dhis2-stable-2.34.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-latest.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.9.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.8.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.7.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.7-EMBARGOED.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.6.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.5.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.3.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.2.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.34/dhis2-stable-2.34.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.33")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.33/dhis2-stable-2.33-eos.war"
    echo "2. https://releases.dhis2.org/2.33/dhis2-stable-2.33.9.war"
    echo "3. https://releases.dhis2.org/2.33/dhis2-stable-2.33.8.war"
    echo "4. https://releases.dhis2.org/2.33/dhis2-stable-2.33.7.war"
    echo "5. https://releases.dhis2.org/2.33/dhis2-stable-2.33.6.war"
    echo "6. https://releases.dhis2.org/2.33/dhis2-stable-2.33.5.war"
    echo "7. https://releases.dhis2.org/2.33/dhis2-stable-2.33.4.war"
    echo "8. https://releases.dhis2.org/2.33/dhis2-stable-2.33.3.war"
    echo "9. https://releases.dhis2.org/2.33/dhis2-stable-2.33.2.war"
    echo "10. https://releases.dhis2.org/2.33/dhis2-stable-2.33.1.war"
    echo "11. https://releases.dhis2.org/2.33/dhis2-stable-2.33.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.9.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.8.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.7.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.6.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.5.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.4.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.3.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.2.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.1.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.33/dhis2-stable-2.33.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.32")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.32/dhis2-stable-2.32-eos.war"
    echo "2. https://releases.dhis2.org/2.32/dhis2-stable-2.32.7.war"
    echo "3. https://releases.dhis2.org/2.32/dhis2-stable-2.32.6.war"
    echo "4. https://releases.dhis2.org/2.32/dhis2-stable-2.32.5.war"
    echo "5. https://releases.dhis2.org/2.32/dhis2-stable-2.32.4.war"
    echo "6. https://releases.dhis2.org/2.32/dhis2-stable-2.32.3.war"
    echo "7. https://releases.dhis2.org/2.32/dhis2-stable-2.32.2.war"
    echo "8. https://releases.dhis2.org/2.32/dhis2-stable-2.32.1.war"
    echo "9. https://releases.dhis2.org/2.32/dhis2-stable-2.32.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.7.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.6.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.5.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.4.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.3.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.2.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.1.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.32/dhis2-stable-2.32.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  "2.31")
    echo ""
    echo "$(tput bold)Please select the specific WAR file URL by entering the corresponding number:$(tput sgr0)"
    echo "1. https://releases.dhis2.org/2.31/dhis2-stable-2.31-eos.war"
    echo "2. https://releases.dhis2.org/2.31/dhis2-stable-2.31.9.war"
    echo "3. https://releases.dhis2.org/2.31/dhis2-stable-2.31.7.war"
    echo "4. https://releases.dhis2.org/2.31/dhis2-stable-2.31.8.war"
    echo "5. https://releases.dhis2.org/2.31/dhis2-stable-latest.war"
    echo "6. https://releases.dhis2.org/2.31/dhis2-stable-2.31.6.war"
    echo "7. https://releases.dhis2.org/2.31/dhis2-stable-2.31.5.war"
    echo "8. https://releases.dhis2.org/2.31/dhis2-stable-2.31.4.war"
    echo "9. https://releases.dhis2.org/2.31/dhis2-stable-2.31.3.war"
    echo "10. https://releases.dhis2.org/2.31/dhis2-stable-2.31.2.war"
    echo "11. https://releases.dhis2.org/2.31/dhis2-stable-2.31.1.war"
    echo "12. https://releases.dhis2.org/2.31/dhis2-stable-2.31.0.war"
    echo ""
    read -p "Enter the number: " dhis_war_choice
    case "$dhis_war_choice" in
      1) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31-eos.war";;
      2) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.9.war";;
      3) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.7.war";;
      4) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.8.war";;
      5) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-latest.war";;
      6) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.6.war";;
      7) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.5.war";;
      8) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.4.war";;
      9) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.3.war";;
      10) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.2.war";;
      11) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.1.war";;
      12) DHIS_WAR_URL="https://releases.dhis2.org/2.31/dhis2-stable-2.31.0.war";;
      *) echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid choice! Exiting..."; exit 1;;
    esac
    ;;
  # Handle other DHIS versions similarly
  *)
    echo "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Invalid DHIS2 version choice! Exiting..."
    exit 1
    ;;
esac

new_env_values=()

# Add DHIS_WAR_URL to new_env_values array
new_env_values+=("$(get_selected_value "$(tput bold)DHIS_WAR_URL" "$(tput setaf 2)$DHIS_WAR_URL$(tput sgr0)")")

# Prompt user for other values with default options
echo ""
echo "$(tput bold)Please provide the following environment variables:$(tput sgr0)"
echo ""

new_env_values=()

# Add DHIS_WAR_URL to new_env_values array
new_env_values+=("$(get_selected_value "$(tput bold)DHIS_WAR_URL" "$(tput setaf 2)$DHIS_WAR_URL$(tput sgr0)")")

new_env_values+=("$(prompt_for_value "$(tput bold)ORGANIZATION_NAME" "$(tput setaf 2)icodebible$(tput sgr0)")")
new_env_values+=("$(prompt_for_value "$(tput bold)DHIS_PROJECT_NAME" "$(tput setaf 2)cainam$(tput sgr0)")")

POSTGRES_DB=("$(prompt_for_value "$(tput bold)POSTGRES_DB" "$(tput setaf 2)codebible$(tput sgr0)")")
POSTGRES_USER=("$(prompt_for_value "$(tput bold)POSTGRES_USER" "$(tput setaf 2)codebible$(tput sgr0)")")
POSTGRES_PASSWORD=("$(prompt_for_value "$(tput bold)POSTGRES_PASSWORD" "$(tput setaf 2)codebible$(tput sgr0)")")

# Automatically assign values after capturing user input

DB_NAME="${POSTGRES_DB#*=}"
DB_USER="${POSTGRES_USER#*=}"
DB_PASSWORD="${POSTGRES_PASSWORD#*=}"

new_env_values+=("$(get_selected_value "$(tput bold)POSTGRES_DB" "$(tput setaf 2)${DB_NAME}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)POSTGRES_USER" "$(tput setaf 2)${DB_USER}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)POSTGRES_PASSWORD" "$(tput setaf 2)${DB_PASSWORD}$(tput sgr0)")")

new_env_values+=("$(get_selected_value "$(tput bold)DB_NAME" "$(tput setaf 2)${DB_NAME}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)DB_USER" "$(tput setaf 2)${DB_USER}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)DB_PASSWORD" "$(tput setaf 2)${DB_PASSWORD}$(tput sgr0)")")

new_env_values+=("$(prompt_for_value "$(tput bold)DB_PORT" "$(tput setaf 2)5432$(tput sgr0)")")

new_env_values+=("$(get_selected_value "$(tput bold)DOCKER_COMPOSE_VERSION" "$(tput setaf 2)${DOCKER_COMPOSE_VERSION}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)CPUS" "$(tput setaf 2)${CPUS}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)MEMORY" "$(tput setaf 2)${MEMORY}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)TZ" "$(tput setaf 2)${TZ}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)DHIS_HOME" "$(tput setaf 2)${DHIS_HOME}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)JDK_JAVA_OPTIONS" "$(tput setaf 2)${JDK_JAVA_OPTIONS}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)POSTGRES_VERSION" "$(tput setaf 2)${POSTGRES_VERSION}$(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)DHIS_VERSION" "$(tput setaf 2)${DHIS_VERSION}$(tput sgr0)")")

new_env_values+=("$(get_selected_value "$(tput bold)POSTGRES_HOST_PORT" "$(tput setaf 2)$(find_random_free_port) $(tput sgr0)")")
new_env_values+=("$(get_selected_value "$(tput bold)DHIS_HOST_PORT" "$(tput setaf 2)$(find_random_free_port) $(tput sgr0)")")


# Display the final values for confirmation
echo ""
echo "$(tput bold)$(tput setaf 2)Here are the values you have provided:$(tput sgr0)"
echo "====================================="
for env_var in "${new_env_values[@]}"; do
  echo "o$env_var"
done

# Output file
output_file=".env"

# Clear the existing .env file
> $output_file

# Confirm if the user wants to update the .env file with these values
read -p "$(tput bold)$(tput setaf 4)Do you want to update the .env file with these values?$(tput sgr0) [y/n]: " confirm_update
if [ "$confirm_update" == "y" ]; then
  echo ""
  echo "$(tput bold)Updating .env file...$(tput sgr0)"
  echo "======================="
  # for env_var in "${new_env_values[@]}"; do
  #   echo "$env_var" >> .env
  # done

  # Extract name and value pairs, remove escape sequences, and append to the .env file
  for env_var in "${new_env_values[@]}"; do
    cleaned_env_var=$(echo -e "$env_var" | sed -e 's/\x1b\[[0-9;]*[a-zA-Z]//g' -e 's/(B//g' -e 's/\[m//g')
    echo "$cleaned_env_var" >> $output_file
  done
  echo "$(tput bold)$(tput setaf 2)Update successful!$(tput sgr0)"
  bash startup.sh
else
  echo ""
  echo "$(tput bold)$(tput setaf 1)Update cancelled.$(tput sgr0)"
fi

echo ""
echo "$(tput bold)$(tput setaf 4)DHIS2 and PostgreSQL setup script completed successfully!$(tput sgr0)"
echo "============================================================="

