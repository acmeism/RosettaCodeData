ack() {
  local m=$1
  local n=$2
  if [ $m -eq 0 ]; then
    echo -n $((n+1))
  elif [ $n -eq 0 ]; then
    ack $((m-1)) 1
  else
    ack $((m-1)) $(ack $m $((n-1)))
  fi
}
