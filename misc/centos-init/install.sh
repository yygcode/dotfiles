#! /bin/bash

# disable command hash
set +h

echo_exit()
{
    echo "ERROR: $@" >&2
    exit 1
}

yes |
sudo yum install \
    man-pages git gcc automake autoconf \
    libevent-devel ncurses-devel \
    texinfo gnutls-devel \
    ||
    echo_exit "Install packages fail"

GDIR=~/git

# tmux
which tmux 2>/dev/null &&
[[ "$(tmux -V)" == "tmux 2.8" ]] ||
(
echo "Begin install tmux"
mkdir -p $GDIR || echo_exit "tmux mkdir $GDIR failed."
cd $GDIR || echo_exit "cd $GDIR failed."
[ -e "tmux/.git" ] || {
    rm -fr tmux
    git clone https://github.com/tmux/tmux.git ||
        echo_exit "tmux git clone failed."
}

cd tmux || echo_exit "tmux cd to tmux failed."
git checkout 2.8 || echo_exit "tmux checkout tag 2.8 failed."
./autogen.sh || echo_exit "tmux autogen failed."
./configure || echo_exit "tmux configure failed."
make || echo_exit "tmux make failed."
sudo make install || echo_exit "tmux make install failed."

echo "Success install tmux"
) || echo_exit "install tmux failed."

# emacs
which emacs 2>/dev/null ||
(
echo "Begin install emacs"
mkdir -p $GDIR || echo_exit "emacs mkdir $GDIR failed"
cd $GDIR || echo_exit "cd $GDIR failed."

[ -e "emacs/.git" ] || {
    rm -fr emacs
    git clone https://git.savannah.gnu.org/git/emacs.git ||
        echo_exit "emacs git clone failed."
}

cd emacs || echo_exit "emacs cd to emacs failed."
git checkout emacs-26.1.92 || echo_exit "emacs checkout tag 26.1.92 failed."

./autogen.sh || echo_exit "emacs autogen.sh failed."
./configure || echo_exit "emacs configure failed."
make -j || echo_exit "emacs make failed."
sudo make install || echo_exit "emacs make install failed."

echo "Success install emacs"
) || echo_exit "install emacs failed."

[ -e "~/.emacs.d" ] ||
{
cd ~
git clone git@github.com:yygcode/.emacs.d
}
