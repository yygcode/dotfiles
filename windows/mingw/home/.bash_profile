# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-4

# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

export PATH=/c/ProgramData/Oracle/Java/javapath:$PATH
export LS_COLORS='no=00:fi=00:di=015;37;44:ln=015;36:pi=40;33:so=015;35:do=015;35:bd=40;33;01:cd=40;33;01:or=015;05;37;41:mi=015;05;37;41:ex=015;32:*.cmd=015;32:*.exe=015;32:*.com=015;32:*.btm=015;32:*.bat=015;32:*.sh=015;32:*.csh=015;32:*.tar=015;31:*.tgz=015;31:*.arj=015;31:*.taz=015;31:*.lzh=015;31:*.zip=015;31:*.z=015;31:*.Z=015;31:*.gz=015;31:*.bz2=015;31:*.bz=015;31:*.tbz2=015;31:*.tz=015;31:*.deb=015;31:*.rpm=015;31:*.rar=015;31:*.ace=015;31:*.zoo=015;31:*.cpio=015;31:*.7z=015;31:*.rz=015;31:*.jpg=015;35:*.jpeg=015;35:*.gif=015;35:*.bmp=015;35:*.ppm=015;35:*.tga=015;35:*.xbm=015;35:*.xpm=015;35:*.tif=015;35:*.tiff=015;35:*.png=015;35:*.mng=015;35:*.xcf=015;35:*.pcx=015;35:*.mpg=015;35:*.mpeg=015;35:*.m2v=015;35:*.avi=015;35:*.mkv=015;35:*.ogm=015;35:*.mp4=015;35:*.m4v=015;35:*.mp4v=015;35:*.mov=015;35:*.qt=015;35:*.wmv=015;35:*.asf=015;35:*.rm=015;35:*.rmvb=015;35:*.flc=015;35:*.fli=015;35:*.gl=015;35:*.dl=015;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.mp3=015;32:*.wav=015;32:*.mid=015;32:*.midi=015;32:*.au=015;32:*.ogg=015;32:*.flac=015;32:*.aac=015;32:'

alias l='ls --show-control-chars --color=auto'
alias la='ls -aF --show-control-chars --color=auto'
alias ll='ls -alF --show-control-chars --color=auto'
alias ls='ls --show-control-chars --color=auto'

# Set PATH so it includes user's private bin if it exists
# if [ -d "${HOME}/bin" ] ; then
#   PATH="${HOME}/bin:${PATH}"
# fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi
