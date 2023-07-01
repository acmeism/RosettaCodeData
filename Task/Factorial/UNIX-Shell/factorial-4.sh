function factorial {
  typeset n=$1
  (( n < 2 )) && echo 1 && return
  echo $(( n * $(factorial $((n-1))) ))
}
