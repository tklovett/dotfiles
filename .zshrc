# Path to your oh-my-zsh installation.
export ZSH=/Users/tlovett/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="lukerandall"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(docker git virtualenv virtualenvwrapper)

# User configuration

export PATH="/Users/tlovett/.nvm/versions/node/v0.12.0/bin:./bin:/usr/local/bin:/usr/local/sbin:/Users/tlovett/.dotfiles/bin:/Users/tlovett/.rbenv/shims:/usr/local/heroku/bin:/usr/local/opt/php53/bin:/usr/local/mysql/bin:/code/android-sdk-macosx/sdk/tools:/usr/local/sbin:/usr/local/bin:/Users/tlovett/code/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/tlovett/.rvm/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Functions
docker_build_and_tag() {
	docker build -t $1 .
}
stop_containers() {
	RUNNING_CONTAINERS=$(docker ps -q | xargs docker inspect -f '{{ .Id }} {{ .Name }}' | grep -v '%patternToSkip%' | awk '{ print $1 }')
	if [ -n "$RUNNING_CONTAINERS" ] 
	then
		echo Stopping running containers: $RUNNING_CONTAINERS
		docker stop $RUNNING_CONTAINERS
	fi
}
gfcify() {
	DATA=~/db/postgres
	mkdir -p ${DATA}
	set -x
	docker run -d --name postgres -v ${DATA}:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:9.4.1
	docker logs -f postgres
}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias please='sudo $(fc -ln -1)'
alias unpip='pip freeze | xargs pip uninstall -y'
alias rmimages='docker rmi $(docker images -q)'
alias rmcontainers='docker rm $(docker ps -a -q)'
alias dbt=docker_build_and_tag
alias shellinit='$(boot2docker shellinit)'
alias dlogin='docker login containers.rmn.io'
alias wut='echo $?'
alias pggiftcards='pgcli postgresql://postgres:password@docker:5432/giftcards'

alias west-prod='ssh_through_perimeter eops-west.wsmeco.com'
alias west2-stage='ssh_through_perimeter eops-west2-stage.wsmeco.com'
alias west-stage='ssh_through_perimeter eops-west-stage.wsmeco.com'
alias west-test='ssh_through_perimeter eops-west-test.wsmeco.com'
alias west-int='ssh_through_perimeter eops-west-int.wsmeco.com'

# Git Aliases
alias gs='git status -sb'
compdef _git gs=git-status
alias gl='git log --oneline --graph --decorate --date=relative --all'
alias rmremote='git push origin --delete'

source ~/.env-vars.sh

# Functions
function dev() {
  open /Applications/iTerm.app/
  open /Applications/Google\ Chrome.app/
  open /Applications/Google\ Chrome.app/
  open /Applications/IntelliJ\ IDEA\ 14.app
  open /Applications/HipChat.app
}
ssh_through_perimeter() {
    perimeter=$1
    if [ -n "$2" ]; then
        hosts=$(ssh "$perimeter" perl -ne "'@a=split(); print \$a[1].\"\n\" if m/$2/'" /etc/hosts | sort )
        if [ -z "$hosts" ]; then
            echo "No hosts matching $2 found"
        elif [ $(echo "$hosts" | wc -l) -gt 1 ]; then
            last=$(echo "$hosts" | tail -n 1)
            echo "Multiple hosts found:"
            echo "$hosts"
            echo "Using $last"
            ssh "$last"
        else
            ssh "$hosts"
        fi
    else
        ssh "$perimeter"
    fi
}
