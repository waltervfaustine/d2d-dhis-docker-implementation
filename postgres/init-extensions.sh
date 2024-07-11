#!/bin/bash
set -e

# SCRIPT DESCRIPTION:
# This script initializes PostgreSQL extensions required for the application.
# It ensures that the necessary extensions are created for enhanced database capabilities.

# USAGE:
# Execute this script within a PostgreSQL container where the necessary environment variables are set.
# Example: ./init-extensions.sh

# PREREQUISITES:
# Ensure the following environment variables are set:
# - POSTGRES_USER: The PostgreSQL user with necessary privileges.

# DOCUMENTATION:

# 1. **Error Handling**:
#    - The script is set to stop execution on error (`set -e`), ensuring that any failure in command execution halts the script immediately.
#    - This prevents the script from continuing with potential errors, improving reliability and ease of debugging.

# 2. **Authentication**:
#    - The script uses the PostgreSQL user provided by the `POSTGRES_USER` environment variable for authentication.
#    - This user must have the necessary privileges to create extensions in the database.

# 3. **PostgreSQL Extensions**:
#    - The script creates the following PostgreSQL extensions if they do not already exist:
#      - **postgis**: Adds support for spatial and geographic objects, enabling spatial queries and GIS capabilities.
#      - **btree_gin**: Enhances the Generalized Inverted Index (GIN), improving indexing performance for certain data types.
#      - **pg_trgm**: Provides trigram matching functionality, useful for text search and similarity measurement.

# 4. **Here-Document for SQL Execution**:
#    - The SQL commands for creating extensions are embedded within a here-document (`EOSQL`), enhancing readability and maintaining a clear separation of SQL code from shell commands.
#    - This approach ensures that the SQL commands are executed in the context of the `psql` command, maintaining clarity and organization.

# 5. **Execution Halt on Failure**:
#    - By setting the `ON_ERROR_STOP=1` variable, the script ensures that any SQL execution error will halt further execution.
#    - Combined with `set -e`, this ensures that errors are caught early, preventing partial or inconsistent extension creation.

# SCRIPT EXECUTION:
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS postgis;
    CREATE EXTENSION IF NOT EXISTS btree_gin;
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
EOSQL
