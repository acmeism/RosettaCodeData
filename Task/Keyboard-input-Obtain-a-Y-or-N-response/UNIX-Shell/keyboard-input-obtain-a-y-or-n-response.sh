getkey() {
  local stty="$(stty -g)"
  trap "stty $stty; trap SIGINT; return 128" SIGINT
  stty cbreak -echo
  local key
  while true; do
    key=$(dd count=1 2>/dev/null) || return $?
    if [ -z "$1" ] || [[ "$key" == [$1] ]]; then
      break
    fi
  done
  stty $stty
  echo "$key"
  return 0
}

yorn() {
  echo -n "${1:-Press Y or N to continue: }" >&2
  local yorn="$(getkey YyNn)" || return $?
  case "$yorn" in
    [Yy]) echo >&2 Y; return 0;;
    [Nn]) echo >&2 N; return 1;;
  esac
}
