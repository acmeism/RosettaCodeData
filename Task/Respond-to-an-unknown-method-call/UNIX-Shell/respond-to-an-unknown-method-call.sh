function handle_error {
  status=$?

  # 127 is: command not found
  if [[ $status -ne 127 ]]; then
    return
  fi

  lastcmd=$(history | tail -1 | sed 's/^ *[0-9]* *//')

  read cmd args <<< "$lastcmd"

  echo "you tried to call $cmd"
}

# Trap errors.
trap 'handle_error' ERR
