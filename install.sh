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

# Check if script is being run non-interactively (e.g., piped through wget)
hostname=""

# First check if a hostname was provided as argument
if [ "$1" != "" ]; then
    hostname="$1"
fi

# If no hostname provided as argument, try to ask interactively
if [ -z "$hostname" ]; then
    # Check if we're in an interactive terminal
    if [ -t 0 ]; then
        read -p "Enter hostname for terminal prompt: " hostname
    else
        # If non-interactive and no argument, use the system's hostname
        hostname=$(hostname)
        echo "Non-interactive mode detected. Using system hostname: $hostname"
    fi
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