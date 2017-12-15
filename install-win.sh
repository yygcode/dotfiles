#! /bin/bash
#
# Install work environment
#
# $0 [arg] [arg]
#
# arg opt:
# f: force install if exists
# d: debug
#
# e.g.: ./install-win.sh f
#


DBG=""
FORCE=""
[ "$1" = "d" -o "$2" = "d" ] && DBG=yes
[ "$1" = "f" -o "$2" = "f" ] && FORCE=yes
REPO_DIR=$(realpath $PWD/$(dirname $0))

echo_base()
{
    local c line func
    c=$(caller 1)
    line=${c%% *}
    func=${c#* }; func=${func%% *}
    echo "[system-config, LINE $line, FUNC $func] $@"
}

echo_dbg()
{
    [ -n "$DBG" ] && echo_base "debug : $@" >&2
}

echo_info()
{
    echo_base "info : $@"
}

echo_warn()
{
    echo_base "warn : $@" >&2
    return 2
}

echo_exit()
{
    echo_base "error : $@" >&2
    exit 1
}

[ -d "$REPO_DIR" ] || echo_exit "could not decide repo directory"
[ -d "$HOME" ] || echo_exit "Please specify env HOME properly"

echo_dbg "repo directory: $REPO_DIR"

# $1 - source directory
# $2 - dest directory, default to HOME
# $3 - limit prefix pattern
# $4 - methods, default to ln -sv
function install_directory_dot_files()
{
    local SD DD PATN CMD OPT EOPT
    SD=$1
    DD=$2
    PATN="'.'* *"
    EOPT="$4"
    [ -d "$SD" ] || echo_exit "invalid source directory '$SD'"
    [ -z "$DD" ] && DD=$HOME
    [ -d "$DD" ] || echo_exit "invalid dest directory '$DD'"
    [ -z "$CMD" ] && CMD="ln -f"
    SD=$(realpath "$SD")
    DD=$(realpath "$DD")
    [ -n "$3" ] && PATN="'$3'*"

    echo_dbg "SD='$SD', DD='$DD', CMD='$CMD'"

    # do work in subshell
    (
	#SD="$REPO_DIR/windows/mingw/home"
	cd $SD || echo_exit "cd to directory '$D' failed"

	ff=/tmp/dotfiles.$BASHPID
	exec 3<>$ff

	# write to pipe
	# unlimit to dot file for recurred subdirectory
	eval ls -ad "$PATN" >$ff || echo_warn "In dir($PWD) ls $PATN* failed"

	# read from pipe
	while read -u 3 x; do
	    [ "$x" = "." -o "$x" = ".." ] && continue
	    echo_dbg "$CMD $SD/$x $DD/"
	    # double safe check
	    [ -z "$x" ] && echo_exit "Impossible empty name '$x' ?"

	    [ -e "$DD/$x" ] && {
		noconfirm="$FORCE"
		MSG="file"
		# always check directory for safety
		[ -d "$DD/$x" ] && { MSG="directory"; noconfirm=""; }

		[ -n "$noconfirm" ] || {
		    read -N 1 -p "Remove exist $MSG '$DD/$x' (Y/N)? " yn
		    echo # force linefeed
		    [ "${yn,,}" = "y" ] || {
			echo_warn "Ignore dot $MSG '$x'"
			continue
		    }
		    # remove directory for ln will fail
		    # force soft link for directory
		    OPT=$EOPT
		    [ -d "$DD/$x" ] && {
			echo_dbg "Remove exist directory $DD/$x"
			OPT="-s"
			rm -fr "$DD/$x"
		    }
		}
	    }
	    echo_dbg $CMD $OPT "$SD/$x" "$DD/"
	    # link failed add soft flag then try again
	    $CMD $OPT "$SD/$x" "$DD/" ||
		$CMD $OPT -s "$SD/$x" "$DD/" ||
		echo_warn "Install dot file fail, try soft link again: '$x'"

	    # recur if $DD/$x is a directory and not ymbolic
	    [ -d "$DD/$x" -a ! -L "$DD/$x" ] && {
		echo_dbg "Not a real link(maybe mingw), recur sub directoy ..."
		(install_directory_dot_files "$SD/$x" "$DD/$x")
	    }
	done
	# cleanup
	rm -f $ff
    ) || exit
}

function install_windows_mingw64()
{
    # we use soft link for directories and hard link for files
    install_directory_dot_files "$REPO_DIR/windows/mingw/home" "" "."
    install_directory_dot_files "$REPO_DIR/common/home"
}

function install_mingw64()
{
    echo_info "Install dot files for mingw64 ..."
    install_windows_mingw64
}

[[ $MSYSTEM = MINGW* ]] && install_mingw64
