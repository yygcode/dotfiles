#! /bin/bash

PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

XTAG="TAG"

TMUX_EXTEND_CMD_DEBUG=1
# Tmux only show stdout, so stderr to stdout
ERRFD=1

echo_debug()
{
    [ -n "TMUX_EXTEND_CMD_DEBUG" ] || return 0
    echo "[$(date +"%F %T")] [DEBUG] $@" >& $ERRFD
    return 0
}

echo_info()
{
    echo "[$(date +"%F %T")] [INFO] $@"
    return 0
}

echo_warn()
{
    echo "[$(date +"%F %T")] [WARN] $@" >& $ERRFD
    return 1
}

echo_error()
{
    echo "[$(date +"%F %T")] [ERROR] $@" >& $$ERRFD
    return 2
}

echo_exit()
{
    echo "[$(date +"%F %T")] [FATAL] $@" >& $ERRFD
    exit 3
    echo_error "BUG: Could not get here !!!"
    return 4
}

# call this if need clear shell output value
stop_mode()
{
    # Alwasy return true
    # tmux send-keys -X cancel
    return 0
}

stop_mode

[[ "$1" == "$XTAG" ]] ||
    echo_exit "Mismatch Argument0 NOT ^TTAG(^T is Ctrl-T)"

cmd_ssh2()
{
    echo "ssh2 Now: $#, $@"
    return 0
}

cmd_ssh()
{
    echo "ssh Now: $#, $@"
#    return 0
    tmux command-prompt -i -p "xxx Extend-Seq-Cmd ssh IP: " \
         "run-shell '~/bin/tmux-extend-seq-cmd.sh TAG ssh ip %%'"
    echo "Args=$#, '$@', 1=$1, 0=$0"
}

cmd_misc()
{
    true
}

XCMD=$2; shift 2

case "$XCMD" in
    "=ssh") cmd_ssh "$@" ;;
    "ssh") cmd_ssh2 "$@" ;;
    *) cmd_misc "$@" ;;
esac

exit 0

# echo "Finish"
# clear buffer
# tmux send-keys -X "cancel"
