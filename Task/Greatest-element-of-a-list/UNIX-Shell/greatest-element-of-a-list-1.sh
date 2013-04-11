max() {
  local m=$1
  shift
  while [ $# -gt 0 ]
  do
    [ "$m" -lt "$1" ] && m=$1
    shift
  done
  echo "$m"
}

max 10 9 11 57 1 12
