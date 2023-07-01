function sum_multiples {
  typeset -i n=$1 limit=$2
  typeset -i max=limit-1
  (( max -= max % n ))
  printf '%d\n' $(( max / n * (n+max)/2 ))
}

function sum35 {
  typeset -i limit=$1
  printf '%d\n' $((  $(sum_multiples  3 $limit)
                   + $(sum_multiples  5 $limit)
                   - $(sum_multiples 15 $limit) ))
}

for (( l=1; l<=1000000000; l*=10 )); do
  printf '%10d\t%18d\n' "$l" "$(sum35 "$l")"
done
