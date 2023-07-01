function move {
  typeset -i n=$1
  typeset from=$2
  typeset to=$3
  typeset via=$4

  if (( n )); then
    move $(( n - 1 )) "$from" "$via" "$to"
    echo "Move disk from pole $from to pole $to"
    move $(( n - 1 )) "$via" "$to" "$from"
  fi
}

move "$@"
