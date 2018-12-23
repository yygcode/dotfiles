#! /bin/bash
#
# Copyright(C) 2018-2020 yonggang.yyg<yygcode@gmail.com>
#
# Install dot files
#

INAME=$(basename $0)
IFORCE=0
ISYSTEM=0
ICMD=
ISOURCEDIR="$(readlink -f $(dirname $0))"
ISYMBOLIC="1"

usage()
{
    echo "Usage: $INAME [options] <TYPE>
Install system customize dot files.

OPTIONS:
  -f|--force        Remove old dot file if exists. Default is ignore exist files.
  -s|--system       Install to system directory. Default is user home directory.
  -h|--help         Print this usage.

TYPE:
  s|symbolic        Create a symbolic. Default is symbolic
  c|copy            Copy files
"
}

echo_warn()
{
    echo "Warn: $(caller 1) $@" >&2
}

echo_error()
{
    echo "Error: $(caller 1) $@" >&2
}


echo_exit()
{
    echo "Error: $(caller 1) $@" >&2
    exit 1
}

for x in "$@"; do
    case "$x" in
        "-f"|"--force")  IFORCE=1 ;;
        "-s"|"--system") ISYSTEM=1 ;;
        "-h"|"--help")   usage; exit 0 ;;
        "s"|"symbolic")  ISYMBOLIC=1 ;;
        "c"|"copy")      ISYMBOLIC=0 ;;
        *)               echo_error "unknown argument $x"; usage; exit 1 ;;
    esac
done

try_remove_file()
{
    [ -n "$1" ] || echo_error "Argument must be a non-empty pathname."

    [ -e "$1" ] || return 0

    # exist but not force
    [ "$IFORCE" = 1 ] || return 1

    [ -f "$1" ] || echo_exit "Argument must be a file"

    rm -f "$1" || {
        echo_warn "Remove file $1 failed."
        return 1
    }

    return 0
}

install_file()
{
    local sf="$ISOURCEDIR/$1"

    [ -f "$1" ] || echo_exit "Argument 1($1) is not a regular file."
    [ -n "$2" ] || echo_exit "Argument 2($2) must be a pathname string."

    try_remove_file "$2"

    $CMD "$sf" "$2" || echo_warn "Install $CMD '$sf' to '$2' failed."
}

install_common()
{
    # tmux
    local c=("tmux.conf")
    local u=("$HOME/.tmux.conf")
    local s=("/etc/tmux.conf")
    local x=("${u[@]}")

    [ "$ISYSTEM" = "1" ] && x=("${s[@]}")

    for ((i = 0; i < ${#x[@]}; ++i)); do
        install_file "common/${c[$i]}" "${x[$i]}"
    done
}

do_install()
{
    [ "$ISYMBOLIC" = "1" ] && CMD="ln -sv"
    [ "$ISYMBOLIC" = "0" ] && CMD="cp -v"

    [ -n "$CMD" ] || echo_exit "Could not decision command."

    install_common
}

do_install
exit 0
