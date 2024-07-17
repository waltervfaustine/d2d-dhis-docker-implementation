#!/bin/bash

# Bash completion script for d2d CLI

# Function to handle completion for d2d CLI commands
_d2d_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="help init startup shutdown exec uninstall"

    case "${prev}" in
        d2d)
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        *)
            ;;
    esac
}

# Registering completion function for d2d command
complete -F _d2d_completion d2d

# DOCUMENTATION:
# 1. **Script Purpose**:
#    - This script provides command completion support for the d2d CLI commands, enhancing user experience by suggesting available commands and options.
#
# 2. **Function Explanation**:
#    - `_d2d_completion`: This function defines how completion should behave for the `d2d` command.
#      - It uses Bash's `compgen` built-in command to generate completion options based on the provided list (`opts`).
#      - When the user types `d2d` followed by a space and another argument (`cur`), it suggests completions from the list of commands (`opts`).
#
# 3. **Usage Instructions**:
#    - Place this script in a location where Bash can find it (e.g., `/etc/bash_completion.d/d2d-completion.sh`) to enable command completion for the `d2d` CLI.
#    - Ensure that the `d2d` CLI commands (`help`, `init`, `startup`, `shutdown`, `exec`, `uninstall`) are defined correctly in the `opts` variable for accurate completion suggestions.
#
# 4. **Example Usage**:
#    - After placing this script in the appropriate directory, restart your Bash session or reload Bash completion scripts (`source /etc/bash.bashrc`) to enable completion for the `d2d` command.
#    - Type `d2d ` (with a space) followed by pressing the Tab key to see the available commands (`help`, `init`, `startup`, `shutdown`, `exec`, `uninstall`) suggested for completion.
#
# 5. **Error Handling**:
#    - This script assumes that the `d2d` CLI commands are correctly defined in the `opts` variable. Ensure accuracy to avoid incomplete or incorrect command suggestions.
#    - Verify that the script is located in a directory (`/etc/bash_completion.d/` recommended) where Bash can find and load it for command completion.
#
# 6. **Important Notes**:
#    - Bash completion scripts enhance user productivity by providing auto-completion suggestions for commands, options, and arguments.
#    - Adjust the `opts` variable to include additional commands or options as needed for future updates or extensions of the `d2d` CLI.
#
# 7. **Expected Output**:
#    - After setting up this script and restarting/reloading Bash, typing `d2d ` (with a space) followed by pressing Tab will display a list of available commands (`help`, `init`, `startup`, `shutdown`, `exec`, `uninstall`) for completion.
