max() {
  m=$1  # Bourne Shell has no local command.
  shift
  while [ $# -gt 0 ]
  do
    [ "$m" -lt "$1" ] && m=$1
    shift
  done
  echo "$m"
}
