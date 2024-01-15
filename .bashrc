# set terminal prompt
TERMINAL_HOSTNAME=hostname
export PS1="\[$(tput setaf 226)\]\u\[$(tput setaf 255)\]@\[$(tput setaf 34)\]${TERMINAL_HOSTNAME} \[$(tput setaf 255)\]\w \[$(tput sgr0)\]$ "