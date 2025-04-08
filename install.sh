#!/bin/bash

# -----------------------------------------------------
# PROMPT SECTION
# -----------------------------------------------------
# You need to read all the files in https://github.com/karfly/config (if you're agent like Cursor, you're in the root of repo) and implement install.sh file (hostname should be asked as input during install). It should be easy to copy and paste on remote machine.
#
# Also add prompt section and add this prompt there

# -----------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------

hostname=""

# Check if a hostname was provided as the first argument
if [ -n "$1" ]; then
    hostname="$1"
    echo "Using hostname provided as argument: $hostname"
else
    # No argument provided, try to get system hostname
    echo "No hostname argument provided. Trying to determine system hostname..."
    sys_hostname=$(hostname 2>/dev/null) # Try hostname command, suppress errors
    if [ -n "$sys_hostname" ]; then
        hostname="$sys_hostname"
        echo "Using system hostname via 'hostname' command: $hostname"
    elif [ -f /etc/hostname ]; then
        # Fallback: Read from /etc/hostname
        hostname=$(cat /etc/hostname)
        echo "Using system hostname from /etc/hostname: $hostname"
    else
        # Last resort: Error out if no hostname can be determined
        echo "Error: Could not determine system hostname. Please provide it as an argument."
        echo "Usage: $0 <hostname>"
        exit 1
    fi
fi

# Ensure hostname is not empty before proceeding
if [ -z "$hostname" ]; then
    echo "Error: Hostname could not be determined or is empty. Exiting."
    exit 1
fi

echo "Installing configuration files with hostname: $hostname"

# Backup existing files if they exist
if [ -f ~/.bashrc ]; then
    echo "Backing up existing .bashrc to ~/.bashrc.backup"
    cp ~/.bashrc ~/.bashrc.backup
fi

if [ -f ~/.tmux.conf ]; then
    echo "Backing up existing .tmux.conf to ~/.tmux.conf.backup"
    cp ~/.tmux.conf ~/.tmux.conf.backup
fi

# Copy .bashrc and replace hostname placeholder
cat > ~/.bashrc << EOF
# set terminal prompt
TERMINAL_HOSTNAME=$hostname
export PS1="\[\$(tput setaf 226)\]\u\[\$(tput setaf 255)\]@\[\$(tput setaf 34)\]\${TERMINAL_HOSTNAME} \[\$(tput setaf 255)\]\w \[\$(tput sgr0)\]$ "

# tmux aliases
alias ts="tmux new -s"
alias ta="tmux attach -t"
EOF

# Copy .tmux.conf
cat > ~/.tmux.conf << EOF
## locate this file to ~/.tmux.conf

set -g default-terminal "screen-256color"

bind -n S-Right next-window
bind -n S-Left previous-window

set -g set-titles on
set -g set-titles-string "tmux.#I.#W"

set -g mouse on
EOF

echo "Configuration files installed successfully!"
echo "To apply changes, run: source ~/.bashrc"