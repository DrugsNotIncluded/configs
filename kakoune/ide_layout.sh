#!/bin/bash -e

#IDE-like tmux layout for kakoune
#Using ranger with customized config as file browser

if [ -z $1 ]; then
    echo "You should specify session name!"
    exit 1
fi

function spawn_kak() {
    	if [ ! -f /tmp/open_with_kak.sh ]; then
        	touch /tmp/open_with_kak.sh
        	echo '#!/bin/bash' >> /tmp/open_with_kak.sh
		echo 'echo "evaluate-commands -client client0 edit $3" | kak -p $1' >> /tmp/open_with_kak.sh
		chmod +x /tmp/open_with_kak.sh
	fi
}

function ranger_kak_tmux() {
	tmux send-keys 'IFS=$'\n' ; env EDITOR="/tmp/open_with_kak.sh '$1'" ranger --cmd="set viewmode multipane" '$2'' Enter
}

export -f ranger_kak

function main() {

#Killing previus kakoune session with the same name if it exists for some reason
rm $XDG_RUNTIME_DIR/kakoune/$1

shopt -s checkwinsize
cat /dev/null
shopt -u checkwinsize

SESSION=$1
FILE=$2
WORKING_DIRECTORY=$( echo $FILE | sed 's|\(.*\)/.*|\1|' )
SIDEBAR_RATIO=7
BTMBAR_RATIO=8  

let SIDEBAR_WIDTH="$COLUMNS/$SIDEBAR_RATIO"
let BTMBAR_HEIGHT="$LINES/$BTMBAR_RATIO"

#Setting up IDE-like tmux layout
tmux start-server
tmux new -d -s $SESSION  #Starting tmux session with given name and immediately detaching
tmux splitw -h
tmux splitw -v

#Additional options
tmux set -g status off
tmux set -g mouse on

#starting kakoune in {1} terminal
#and ranger in {0} terminal

tmux selectp -t 1;
tmux send-keys "kak -s $SESSION $FILE" Enter
tmux selectp -t 0;
ranger_kak_tmux $SESSION $WORKING_DIRECTORY

tmux attach-session -t $SESSION \; resize-pane -t 0 -x $SIDEBAR_WIDTH \; resize-pane -t 2 -y $BTMBAR_HEIGHT
}

spawn_kak
trap 'main $@' EXIT
echo 'evaluate-commands -client client0 quit! ' | kak -p $1
tmux kill-session -t $1
echo "Exit!"
