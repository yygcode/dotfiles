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
    tmux send-keys -X cancel
    return 0
}

stop_mode

# [[ "$1" == "$XTAG" ]] ||
#    echo_exit "Mismatch Argument0 NOT ^TTAG(^T is Ctrl-T)"

cmd_init()
{
    tmux new-window -a
    tmux splitw -t .1 -h -c '#{pane_current_path}'
    tmux splitw -t .1 -v -c '#{pane_current_path}'
    tmux splitw -t .3 -v -c '#{pane_current_path}'
}

cmd_log()
{
    for i in {1..4}; do
        tmux send-keys -t .$i "C-c"
        tmux send-keys -t .$i \
             "tail -f /var/log/messages" Enter
    done
}

cmd_run()
{
    for i in {1..4}; do
        tmux send-keys -t .$i "C-c"
        tmux send-keys -t .$i "top" Enter
    done
}

cmd_misc()
{
#    tmux command-prompt  -p "Extend-Seq-Cmd: ssh " \
    #         "run-shell '~/bin/tmux-extend-seq-cmd.sh TAG ssh %%'"
    true
}

XCMD=$2; shift 2

case "$XCMD" in
    "i") cmd_init "$@" ;;
    "l") cmd_log "$@" ;;
    "r") cmd_run "$@" ;;
    *) cmd_misc "$@" ;;
esac

exit 0

# echo "Finish"
# clear buffer
# tmux send-keys -X "cancel"
