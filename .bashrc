# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# .NET 10 - must be before interactive check (for OpenCode/non-interactive shells)
export DOTNET_ROOT=$HOME/.dotnet
export PATH="$HOME/.dotnet:$PATH"

# npm global packages - user directory (prevents permission issues)
export PATH=~/.npm-global/bin:$PATH

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

promptDebian='󰣚'

build_prompt() {
    local user="jirka"
    local icon="\[\033[01;31m\]${promptDebian}\[\033[00m\]"
    local dir="\[\033[01;34m\]\w\[\033[00m\]"
    local dollar="\[\033[01;33m\]\$\[\033[00m\]"
    
    PS1="${user}${icon}:${dir}${dollar} "
}

PROMPT_COMMAND=build_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"

alias fm=yazi
alias oc='~/.local/bin/opencode-fixedport'  # OpenCode with fixed port for voice assistant

alias ll="eza -l --icons=auto"
alias la="eza -la --icons=auto"
# HyperHDR backlight - start/stop
# Použití: bl start | bl stop
bl() {
    case "$1" in
        start)
            ~/.local/bin/start-hyperhdr.sh
            ;;
        stop)
            ~/.local/bin/stop-hyperhdr.sh
            ;;
        *)
            echo "Použití: bl start|stop"
            ;;
    esac
}
alias backlight="bl"
alias edit="code"
# DOTNET_ROOT a PATH pro .dotnet jsou nastaveny na začátku souboru (před interactive check)
export PATH=$PATH:$HOME/.dotnet/tools
export PATH="$PATH:/opt/mssql-tools18/bin"

# zruš případný alias ls, aby fungovala funkce
unalias ls 2>/dev/null

function ls {

    if [ "$1" = "-latr" ]; then
        shift
        eza -la --icons=auto --sort=modified --reverse "$@"
    else
        eza --icons=auto "$@"
    fi
}



# Google Cloud Speech-to-Text credentials
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.secrets/google-cloud-speech.json"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jirka/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jirka/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jirka/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jirka/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# CUDA Toolkit path
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$HOME/.local/lib:$LD_LIBRARY_PATH"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# zoxide - smarter cd command
eval "$(zoxide init bash)"

alias gemini="gemini --approval-mode yolo"

# Auto-start Zellij in Alacritty (not in VS Code or SSH)
# if [[ -z "$ZELLIJ" && "$TERM_PROGRAM" != "vscode" && -z "$SSH_CONNECTION" && "$TERM" == "alacritty" ]]; then
#     exec zellij attach -c main
# fi

# Zellij – spouštět pouze v Alacritty (ne v Kitty, VS Code nebo SSH)
#[[ -z "$ZELLIJ" && "$TERM" == "alacritty" && "$TERM_PROGRAM" != "vscode" && -z "$SSH_CONNECTION" ]] && exec zellij




# VirtualAssistant Services helper function
# Usage: va start | va stop | va status | va logs [service]
va() {
    case "$1" in
        start)
            ~/.local/bin/virtual-assistant-start-services.sh
            ;;
        stop)
            ~/.local/bin/virtual-assistant-stop-services.sh
            ;;
        status)
            echo "📊 VirtualAssistant Services Status:"
            echo ""
            # Note: edge-tts-server removed - now using Edge TTS via WebSocket directly
            for svc in "virtual-assistant.service:VirtualAssistant (port 5055)" "log-viewer.service:log-viewer (port 5053)"; do
                service="${svc%%:*}"
                name="${svc##*:}"
                if systemctl --user is-active --quiet "$service" 2>/dev/null; then
                    echo -e "  \033[0;32m✓\033[0m $name"
                else
                    echo -e "  \033[0;31m✗\033[0m $name (not running)"
                fi
            done
            ;;
        logs)
            local service="${2:-va}"
            case "$service" in
                va|virtual-assistant) service="virtual-assistant.service" ;;
                logs|log-viewer) service="log-viewer.service" ;;
                *) service="${service}.service" ;;
            esac
            journalctl --user -u "$service" -f
            ;;
        restart)
            ~/.local/bin/virtual-assistant-stop-services.sh
            sleep 1
            ~/.local/bin/virtual-assistant-start-services.sh
            ;;
        *)
            echo "VirtualAssistant Services Manager"
            echo ""
            echo "Usage: va <command>"
            echo ""
            echo "Commands:"
            echo "  start    - Start all development services"
            echo "  stop     - Stop all development services"
            echo "  restart  - Restart all services"
            echo "  status   - Show service status"
            echo "  logs [service] - Follow logs (default: va)"
            echo ""
            echo "Services: va (virtual-assistant), logs (log-viewer)"
            ;;
    esac
}
export DISABLE_AUTOUPDATER=1

# Cline CLI helper - open last task with yolo mode
alias clt='cline task open $(cline task list 2>/dev/null | grep "Task ID:" | tail -1 | awk "{print \$3}") -y -m act && cline task chat'

# OpenCode - use safe wrapper to prevent running in home directory
alias opencode="opencode-safe"

# GitHub Issues Search - start/stop
# Usage: gi start | gi stop
gi() {
    case "$1" in
        start)
            ~/.local/bin/github-start.sh
            ;;
        stop)
            ~/.local/bin/github-stop.sh
            ;;
        stop)
            ~/.local/bin/github-stop.sh
            ;;
        *)
            echo "GitHub Issues Search Manager"
            echo ""
            echo "Usage: gi <command>"
            echo ""
            echo "Commands:"
            echo "  start  - Start all services (runners, ngrok, app)"
            echo "  stop   - Stop all services"
            ;;
    esac
}

# Docker containers management (mssql, searxng)
# Usage: co start | co stop | co status
co() {
    case "$1" in
        start)
            ~/.local/bin/vas-start.sh
            ;;
        stop)
            ~/.local/bin/vas-stop.sh
            ;;
        status)
            echo "Docker containers:"
            docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
            ;;
        *)
            echo "Docker Containers Manager"
            echo ""
            echo "Usage: co <command>"
            echo ""
            echo "Commands:"
            echo "  start  - Start containers (mssql, searxng)"
            echo "  stop   - Stop containers"
            echo "  status - Show running containers"
            ;;
    esac
}

# All services management
# Usage: all stop
all() {
    case "$1" in
        stop)
            echo "Stopping all services..."
            va stop
            gi stop
            co stop
            bl stop
            echo "All services stopped."
            ;;
        *)
            echo "Usage: all stop"
            ;;
    esac
}
