# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

# Path to your oh-my-zsh installation.
export ZSH=/Users/tlovett/.oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line if you want to change the command execution time stamp shown in the history command output.
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(docker git colored-man-pages)

export PATH="$PATH:/bin"
export PATH="$PATH:/sbin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/Users/tlovett/.rvm/bin"
export PATH="$PATH:/Users/tlovett/.rbenv/shims"
export PATH="$PATH:/opt/X11/bin"
export PATH="$PATH:/usr/local/mysql/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin"

export KUBECONFIG=~/.kube/config:$KUBECONFIG

# virtualenvwrapper - http://virtualenvwrapper.readthedocs.io/en/latest/install.html#shell-startup-file
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/code
source /usr/local/bin/virtualenvwrapper.sh

# User configuration
export PIP_REQUIRE_VIRTUALENV=true
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Functions
source $HOME/.docker_functions
source $HOME/.kubernetes_functions
source $HOME/.aws_profile_functions
if [ -f $HOME/.env-specific.sh ]; then
	source $HOME/.env-specific.sh
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs, plugins, and themes.
# For a full list of active aliases, run `alias`.
alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias please='sudo $(fc -ln -1)'
alias unpip='pip freeze | xargs pip uninstall -y'
alias wut='echo $?'
alias up='cd ..'
alias json_pretty='python -m json.tool'

# Git Aliases
alias gs='git status -sb'
compdef _git gs=git-status
alias gl='git log --oneline --graph --decorate --date=relative'
alias gla='gl --all'
alias rmremote='git push origin --delete'
alias uncommit='git reset --soft HEAD~1'

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault
