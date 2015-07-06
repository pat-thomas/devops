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

function main () {
  local user_input=$1
  if [ "$user_input" == "" ]; then
    echo "Error: Must provide a session name."
    echo "Try one of these projects:"
    for d in $(ls ~/projects/personal); do
      echo $d
    done
    exit 0
  elif [ "$user_input" == "suicide" ]; then
    kill_session $(basename "$(pwd)")
  elif [ "$user_input" == "ls" ]; then
    current_tmux_sessions
    exit 0
  else
    attempt_to_join_session $1
  fi
}

main $1
