for ((val=1;;val++)) {
  print $val
  (( val % 6 )) || break
}
