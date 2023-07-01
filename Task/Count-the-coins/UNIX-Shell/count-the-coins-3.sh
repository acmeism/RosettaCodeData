function count_change {
  typeset -i amount=$1 coin j
  typeset ways
  set -A ways 1
  shift
  for coin; do
    let j=coin
    while (( j <= amount )); do
      let ways[j]=${ways[j]:-0}+${ways[j-coin]:-0}
      let j+=1
    done
  done
  echo "${ways[amount]}"
}
count_change 100 25 10 5 1
# (optional task exceeds a subscript limit in ksh88)
