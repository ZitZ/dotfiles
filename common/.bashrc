# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

### Paul's User .bashrc file
### /home/paul/.bashrc

#export TERM=xterm-256color
set -o vi
clear
TMOUT=0


which curl > /dev/null || echo "The curl packages is not installed which is necessary for certain features. Install cli_common."

clear
tput cup 10000 0
which neofetch > /dev/null && neofetch --disable de wm resolution


# directory to store other specific bash files not for use on all setups
if [ -d ~/.bash ]; then
	for f in ~/.bash/*; do source $f; done;
fi

## things I don't want public
if [[ -f ~/.bash_dark ]]; then
	. ~/.bash_dark
fi

## my file where I store server specific applications to start
if [[ -f ~/.bash_start ]] && [[ ! -f /tmp/bash_start.pid ]]; then
	. ~/.bash_start
	touch /tmp/bash_start.pid
fi

# kde overrides this
# a small script is in ~/.kde/autostart
if [ -f ~/.Xdefaults ] && [ -z "$HEADLESS" ]; then
  xrdb -load ~/.Xdefaults
fi

## Run the universal program for connecting network shares and syncing config files
if [ -f ~/.local/bin/BrakConnections ]; then
  source ~/.local/bin/BrakConnections
fi

### Startx on Login
### For this to work $SERVER and $HEADLESS must be set in .profile before this file is sourced
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]] && [[ $SERVER ]] && [[ ! $HEADLESS ]]; then
	startx
fi


## Configure Colors
PROMPTGREEN='\e[0;32m'
# bash colors
if [ -f ~/.bash_color ]; then
  . ~/.bash_color
  PROMPTGREEN=$IGreen
fi

###Colorizied Command Prompt
## Red Prompt, Blue Directory, Green text
env | grep BASH && PS1="\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \t \[\e[0;31m\]\$ \[\e[m\]\[$PROMPTGREEN\]"

## Custom Aliases
alias gpg='gpg2'
alias weather='curl http://wttr.in'
alias moon='curl http://wttr.in/Moon'
alias mednafen='pasuspender; mednafen -sound.device sexyal-literal-default -video.fs 1'
alias mc='mc -S dark'
alias ncmpc='ncmpc -c'
alias ncmpcpp='ncmpcpp -h $MPD_HOST'
alias img='fim -d /dev/fb0 -o fb --no-history-save -a'
alias fim='fim --no-history-save -a'
alias rg='snap run rg -L'
alias f='fish'
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias t='tmux'
alias cstyler='astyle -z2 --style=break --indent=spaces -k1 -e -xb -j -c'



export CHEATCOLORS=true
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  export CHEATCOLORS=true
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  which exa &> /dev/null && alias ls='exa'
  alias grep='grep --color=auto'
  alias pacman='pacman-color'
fi
export CHEAT_PATH="$HOME/.cheat:$HOME/git/cheatsheets"

## make folders for vim backups
mkdir -p  ~/.cache/vtemp/backup
mkdir -p ~/.cache/vtemp/swap
mkdir -p ~/.cache/vtemp/undo/


EDITOR=vim
alias vim='vim -u ~/.config/nvim/global.vim'
# use neovim if it is installed and spacevim
if which nvim &> /dev/null; then
  alias vim=/usr/local/bin/nvim
  export EDITOR=/usr/local/bin/nvim
fi

export MANPAGER="env MAN_PN=1 nvim -M +MANPAGER -"

#alias python='/usr/bin/python3.6'

## Music Player Daemon Controls and Set Desktop Background to current album art
if [ -n "$HOMENETWORK" ] && [ -z "$SERVER" ] && [ -z "$HEADLESS" ] && [ -n "$MUSICDIR" ] && [ -n "$MPD_HOST" ]; then
  #~/.local/bin/setCoverArt $MPD_HOST
  if [ ! -f /tmp/mpc-next ]; then
    touch /tmp/mpc-next;
    while true; do 
      #kdialog --title "Now Playing" --passivepopup "$(mpc current --wait)" 10;
      echo "$(mpc -h $MPD_HOST current --wait)" >> /tmp/notifications
      #~/.local/bin/setCoverArt $MPD_HOST;
      sleep 15;
      done &
  fi
fi

### Paths
test -d ~/.local/bin && export PATH=$PATH:~/.local/bin
test -d ~/.cargo && export PATH=$PATH:~/.cargo/bin
#export PATH=/opt/android-sdk-linux/tools:$PATH
#export PATH=/opt/android-sdk-linux/platform-tools:$PATH

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
env | grep BASH && test -f /etc/bash_completion && . /etc/bash_completion

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

## Disable Caps Lock Key
if which xmodmap &> /dev/null && which setxkbmap &> /dev/null; then
  #setxkbmap -layout us -option ctrl:nocaps
  #xmodmap -e 'clear Lock'
  #xmodmap -e 'keycode 0x7e = Control_R'
  #xmodmap -e 'add Control = Control_R'
fi


function file_replace() {
  for file in $(find . -type f -name "$1*"); do
    mv $file $(echo "$file" | sed "s/$1/$2/");
  done
}


function dir_replace() {
  for file in $(find . -type d -name "$1*"); do
    mv $file $(echo "$file" | sed "s/$1/$2/");
  done
}

export NNN_TMPFILE="$HOME/.config/nnn/.lastd"
n()
{
  nnn "$@"
  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
  fi
}

if which fish &> /dev/null; then
  rm -f ~/.config/fish/alias.fish
  echo "$(alias)" > ~/.config/fish/alias.fish
  #/usr/bin/fish
fi
# append to the history file, don't overwrite it
env | grep BASH && shopt -s histappend
