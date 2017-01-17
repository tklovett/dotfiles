# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

# Path to your oh-my-zsh installation.
export ZSH=/Users/tlovett/.oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/
ZSH_THEME="tlovett"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line if you want to change the command execution time stamp shown in the history command output.
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(docker git virtualenv virtualenvwrapper colored-man-pages colorize extract adb gradle)

# User configuration

export PATH="$PATH:./bin:/usr/local/bin:/usr/local/sbin:/Users/tlovett/.dotfiles/bin:/Users/tlovett/.rbenv/shims:/usr/local/heroku/bin:/usr/local/opt/php53/bin:/usr/local/mysql/bin:/code/android-sdk-macosx/sdk/tools:/usr/local/sbin:/usr/local/bin:/Users/tlovett/code/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/tlovett/.rvm/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

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

# Set personal aliases, overriding those provided by oh-my-zsh libs, plugins, and themes.
# For a full list of active aliases, run `alias`.
alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias please='sudo $(fc -ln -1)'
alias unpip='pip freeze | xargs pip uninstall -y'
alias rmimages='docker rmi $(docker images -q)'
alias rmcontainers='docker rm $(docker ps -a -q)'
alias dbt=docker_build_and_tag
alias dlogin='docker login containers.rmn.io'
alias wut='echo $?'
alias pggiftcards='pgcli postgresql://postgres:password@docker:5432/giftcards'
alias catplain='/bin/cat'
alias cat='colorize'
alias up='cd ..'

# Git Aliases
alias gs='git status -sb'
compdef _git gs=git-status
alias gl='git log --oneline --graph --decorate --date=relative'
alias gla='gl --all'
alias rmremote='git push origin --delete'
alias uncommit='git reset --soft HEAD~1'
branch() {
	git checkout -b tl-$1-$2
}

if [ -f "~/.env-specific.sh" ]; then
	source ~/.env-specific.sh
fi

PATH="/Users/tlovett/perl5/bin${PATH:+:${PATH}}"; export PATH;
