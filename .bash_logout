# ~/.bash_logout: executed by bash(1) when login shell exits.

# ssh-agent
[ -x ssh-agent ] && ssh-agent -k

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi