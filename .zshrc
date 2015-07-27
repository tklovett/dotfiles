# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

# Path to your oh-my-zsh installation.
export ZSH=/Users/tlovett/.oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/
ZSH_THEME="lukerandall"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time stamp shown in the history command output.
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(docker git virtualenv virtualenvwrapper)

# User configuration

export PATH="/Users/tlovett/.nvm/versions/node/v0.12.0/bin:./bin:/usr/local/bin:/usr/local/sbin:/Users/tlovett/.dotfiles/bin:/Users/tlovett/.rbenv/shims:/usr/local/heroku/bin:/usr/local/opt/php53/bin:/usr/local/mysql/bin:/code/android-sdk-macosx/sdk/tools:/usr/local/sbin:/usr/local/bin:/Users/tlovett/code/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/tlovett/.rvm/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

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

# Set personal aliases, overriding those provided by oh-my-zsh libs, plugins, and themes.
# For a full list of active aliases, run `alias`.
alias please='sudo $(fc -ln -1)'
alias unpip='pip freeze | xargs pip uninstall -y'
alias rmimages='docker rmi $(docker images -q)'
alias rmcontainers='docker rm $(docker ps -a -q)'
alias dbt=docker_build_and_tag
alias shellinit='$(boot2docker shellinit)'
alias dlogin='docker login containers.rmn.io'
alias wut='echo $?'
alias pggiftcards='pgcli postgresql://postgres:password@docker:5432/giftcards'
alias b2d='boot2docker'

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
