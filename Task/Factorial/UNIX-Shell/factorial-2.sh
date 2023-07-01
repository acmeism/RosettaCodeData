function factorial {
  typeset n=$1 f=1 i
  for ((i=2; i < n; i++)); do
    (( f *= i ))
  done
  echo $f
}
