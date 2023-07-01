function count_change {
  typeset -i amount=$1 coin j
  typeset ways
  set -A ways 1
  shift
  for coin; do
    for (( j=coin; j <= amount; j++ )); do
      let ways[j]=${ways[j]:-0}+${ways[j-coin]:-0}
    done
  done
  echo "${ways[amount]}"
}
count_change 100 25 10 5 1
count_change 100000 100 50 25 10 5 1
