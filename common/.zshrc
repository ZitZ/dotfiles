source ~/.bashrc

# installed from debian packages
# syntax highlighting and autocompletion are different things
test -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.sh && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
test -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# manual install
test -f ~/git/zsh-autosuggestions/zsh-autosuggestions.zsh && source ~/git/zsh-autosuggestions/zsh-autosuggestions.zsh
test -f ~/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source ~/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# https://gist.github.com/matthewmccullough/787142
##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# https://github.com/zsh-users/zsh-autosuggestions/issues/515
autoload compinit && compinit

# https://github.com/denysdovhan/spaceship-prompt
fpath=( "$HOME/.zfunctions" $fpath )
autoload -U promptinit; promptinit
prompt spaceship
