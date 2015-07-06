function current_tmux_sessions () {
  tmux list-sessions | cut -f1 -d\:
}

function kill_session() {
  local session=$1
  tmux kill-session -t $session
}

function attempt_to_join_session() {
  local target_session=$1
  for session in $(current_tmux_sessions | grep $target_session); do
    if [ "$session" == "$target_session" ]; then
      tmux attach -t $target_session
      exit 0
    fi
  done

  echo "No session found matching $target_session"
}

function create_or_join_session() {
  local target_session=$1
  attempt_to_join_session $target_session

	tmux new -d                         -s $target_session -n emacs
	tmux new-window -n 'vim'            -t $target_session
	tmux new-window -n 'services'       -t $target_session
	tmux new-window -n 'build-services' -t $target_session
	tmux new-window -n 'git'            -t $target_session
	tmux new-window -n 'repl'           -t $target_session
	tmux new-window -n 'remote'         -t $target_session
	tmux new-window -n 'dbshell'        -t $target_session
	tmux new-window -n 'tests'          -t $target_session
	tmux new-window -n 'misc'           -t $target_session
  tmux select-window                  -t $target_session:4 # Chances are you want to select the 'git' window on startup
                                                           # to pull recent changes. If not, just choose a different number.
	tmux attach-session                 -t $target_session
}

function main () {
  local user_input=$1
  if [ "$user_input" == "" ]; then
    echo "Error: Must provide a session name."
    echo "Try one of these projects:"
    for d in $(ls ~/projects/personal); do
      echo $d
    done
    exit 0
  elif [ "$user_input" == "--here" ]; then
    create_or_join_session $(basename "$(pwd)")
  elif [ "$user_input" == "ls" ]; then
    current_tmux_sessions
    exit 0
  elif [ "$user_input" == "suicide" ]; then
    kill_session $(basename "$(pwd)")
  else
    attempt_to_join_session $1
  fi
}

main $1
