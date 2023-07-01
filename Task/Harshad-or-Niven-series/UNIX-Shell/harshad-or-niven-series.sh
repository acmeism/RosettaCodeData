function main {
  local -i i=0 n
  gen_harshad | while read n; do
    if (( !i )); then
      printf '%d' "$n"
    elif (( i < 20 )); then
      printf ' %d' "$n"
    elif (( i == 20 )); then
      printf '\n'
    elif (( n > 1000 )); then
      printf '%d\n' "$n"
      return
    fi
    (( i++ ))
  done
}

function is_harshad {
  local -i sum=0 n=$1  i
  for (( i=0; i<${#n}; ++i )); do
    (( sum += ${n:$i:1} ))
  done
  (( n % sum == 0 ))
}

function gen_harshad {
  local -i i=1
  while true; do
    if is_harshad $i; then
      printf '%d\n' "$i"
    fi
    (( i++ ))
  done
}

main "$@"
