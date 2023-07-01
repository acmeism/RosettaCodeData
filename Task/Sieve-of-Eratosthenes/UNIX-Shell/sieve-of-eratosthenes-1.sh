function primes {
  typeset -a a
  typeset i j
  a[1]=""
  for (( i = 2; i <= $1; i++ )); do
    a[$i]=$i
  done
  for (( i = 2; i * i <= $1; i++ )); do
    if [[ ! -z ${a[$i]} ]]; then
      for (( j = i * i; j <= $1; j += i )); do
        a[$j]=""
      done
    fi
  done
  printf '%s' "${a[2]}"
  printf ' %s' ${a[*]:3}
  printf '\n'
}

primes 1000
