function invmod {
  typeset -i a=$1 n=$2
  if (( n < 0 )); then (( n = -n )); fi
  if (( a < 0 )); then (( a = n - (-a) % n )); fi

  typeset -i t=0 nt=1 r=n nr q tmp
  (( nr = a % n ))
  while ((  nr )); do
    (( q = r/nr ))
    (( tmp = nt ))
    (( nt = t - q*nt ))
    (( t = tmp ))
    (( tmp = nr ))
    (( nr = r - q*nr ))
    (( r = tmp ))
  done
  if (( r > 1 )); then
    return 1
  fi
  while (( t < 0 )); do (( t += n )); done
  printf '%s\n' "$t"
}

invmod 42 2017
