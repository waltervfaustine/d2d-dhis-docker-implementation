#!/bin/bash

# Perform environment variable substitution on the DHIS2 configuration template
envsubst < /usr/local/tomcat/conf/dhis.conf.template > $DHIS_HOME/dhis.conf

# Set restrictive permissions for the DHIS2 configuration file
chmod 600 $DHIS_HOME/dhis.conf

# Start the Tomcat server to run the DHIS2 application
exec catalina.sh run

# DOCUMENTATION:
# 1. **Environment Variable Substitution**:
#    - The `envsubst` command substitutes environment variables in the `dhis.conf.template` file with their corresponding values and outputs the result to `$DHIS_HOME/dhis.conf`.
# 2. **Set File Permissions**:
#    - The `chmod 600` command sets restrictive permissions on the generated `dhis.conf` file, ensuring it is readable and writable only by the owner. This enhances security by protecting sensitive configuration data.
# 3. **Start Tomcat Server**:
#    - The `exec catalina.sh run` command replaces the current shell process with the Tomcat startup script, starting the Tomcat server to run the DHIS2 application. Using `exec` ensures that Tomcat takes over the container process, enabling proper signal handling and shutdown.
# 4. **Script Execution**:
#    - This script is designed to be executed as the entry point for a Docker container running Tomcat with DHIS2. Ensure that the script has execute permissions (`chmod +x entry-point.sh`) before use.
