#! /bin/bash
#
# Copyright(C) 2018-2020 yonggang.yyg<yygcode@gmail.com>
#
# Install dot files
#

# check OS
OS="$(uname -s)"
WD=$(dirname "$0")
[[ -z "$WD" ]] && WD="."

function is_darwin()
{
    [[ "$OS" = "Darwin" ]] && return 0
    return 1
}
function is_linux()
{
    [[ "$OS" = "Linux" ]] && return 0
    return 1
}

INAME=$(basename $0)
IFORCE=0
ISYSTEM=0
ICMD=
is_linux && ISOURCEDIR="$(readlink -f $(dirname $0))"
is_darwin && ISOURCEDIR="$PWD"
ISYMBOLIC="1"

# See https://en.wikipedia.org/wiki/ANSI_escape_code
# and https://zh.wikipedia.org/zh-hans/ANSI%E8%BD%AC%E4%B9%89%E5%BA%8F%E5%88%97
# and https://misc.flogisoft.com/bash/tip_colors_and_formatting
COLOR_DEFAULT="\e[0m"
COLOR_ERROR="\e[31;49m\e[1m"
COLOR_WARN="\e[31;49m\e[1m"
COLOR_INFO="\e[34;49m\e[1m"

usage()
{
    echo "Usage: $INAME [options] - Install system customize dot files.

OPTIONS:
  -f|--force          Remove old dot file if exists. Default ignore exist files.
  -s|--system         Install to system directory. Default is HOME directory.
  -h|--help           Print this usage.
  -S|--sym|--symbolic Create a symbolic. Default is symbolic
  -c|-copy            Copy files

Platform:
  1. Mac(Darwin) only support short options.
  2. Mac need install bash, suggest use brew
"
}

echo_error()
{
    # mac does not support echo -e, use printf
    printf "[${COLOR_ERROR}ERROR${COLOR_DEFAULT}] $(caller 0) $@\n" >&2
}

echo_warn()
{
    printf "[${COLOR_WARN}WARN${COLOR_DEFAULT}] $(caller 0) $@\n" >&2
}

echo_info()
{
    printf "[${COLOR_INFO}INFO${COLOR_DEFAULT}] $(caller 0) $@\n" >&2
}

echo_exit()
{
    printf "[${COLOR_ERROR}ERROR${COLOR_DEFAULT}] $(caller 0) $@\n" >&2
    exit 1
}

# rebase arguments
getopt_darwin()
{
    set -- $(getopt "fshSc" "$@")
}

getopt_linux()
{
    set -- $(getopt -o"fshSc" -l"force,system,help,sym,symbolic,copy" -- "$@")
}

is_darwin && getopt_darwin "$@"
is_linux && getopt_linux "$@"

for x in "$@"; do
    case "$x" in
        "-f"|"--force")            IFORCE=1;;
        "-s"|"--system")           ISYSTEM=1;;
        "-h"|"--help")             usage; exit 0;;
        "-S"|"--sym"|"--symbolic") ISYMBOLIC=1;;
        "-c"|"--copy")             ISYMBOLIC=0;;
        "-"|"--")                  ;;
        *) echo_error "unknown argument $x"; usage; exit 1 ;;
    esac
done

try_remove_file()
{
    [ -n "$1" ] || echo_error "Argument must be a non-empty pathname."

    [ -e "$1" ] || [ -L "$1" ] || return 0

    # exist but not force
    [ "$IFORCE" = 1 ] || return 1

    [ -f "$1" ] || [ -L "$1" ] || echo_exit "Argument must be a file"

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

    $CMD "$sf" "$2" >/dev/null &&
        echo_info "Install success: $CMD '$sf' to '$2'" ||
        echo_error "Install failed: $CMD '$sf' to '$2'"
}

# call: conf-list-array directory-prefix
install_exec()
{
    # tmux
    local dir=$1; shift
    local cl=("$@")

    local cs="${#cl[@]}"
    local offset=1

    [ -d "$dir" ] ||
        echo_exit "invalid directory $dir"
    [ "$(((cs/3)*3))" = "$cs" ] ||
        echo_exit "conf list format error: $dir(list: $cs, ${cl[@]})"

    [ "$ISYSTEM" = "1" ] && offset=2

    for ((i = 0; i < cs; i += 3)); do
        local dest="${cl[$((i+offset))]}"
        [ -z "$dest" ] && dest="${cl[$((i+1))]}"
        [ -z "$dest" ] &&
            echo_exit "could not decide destinaton for $dir/${cl[$i]}"

        local destdir=$(dirname "$dest")
        [ -d "$destdir" ] || mkdir -p "$destdir" ||
            echo_exit "create not exitst directory failed: $destdir"

        install_file "$dir/${cl[$i]}" "$dest"
    done
}

install_common()
{
    # tmux
    local cl=(
        "tmux.conf" "$HOME/.tmux.conf" "/etc/tmux.conf"
        "bash_alias" "$HOME/.bash_alias" ""
    )

    install_exec "common" "${cl[@]}"
}

install_misc()
{
    tic -x -o ~/.terminfo misc/terminfo-24bit.src ||
        echo_exit "Install terminfo-24bit failed."
    echo_info "install term-24bits success."
}

install_linux()
{
    # terminator
    local cl=(
        "terminator_config" "$HOME/.config/terminator/config" ""
        "bashrc" "$HOME/.bashrc" ""
        "bash_profile" "$HOME/.profile" ""
    )

    install_exec "linux" "${cl[@]}"
}

install_darwin()
{
    # always compatible with linux
    install_linux

    # need ~/.bash_profile
    local cl=(
        "bash_profile" "$HOME/.bash_profile" ""
    )

    install_exec "darwin" "${cl[@]}"
}

do_install()
{
    [ "$ISYMBOLIC" = "1" ] && CMD="ln -sv"
    [ "$ISYMBOLIC" = "0" ] && CMD="cp -v"

    [ -n "$CMD" ] || echo_exit "Could not decision command."

    install_common
    install_misc
    is_linux && install_linux
    is_darwin && install_darwin
}

# ensure to work directory
cd "$WD" || echo_exit "cd to work directory $WD failed"
do_install
exit 0
