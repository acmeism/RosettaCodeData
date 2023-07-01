sierpinski_carpet() {
  typeset -i n=${1:-3}
  if (( n < 1 )); then
    return 1
  fi
  typeset -i size x y
  typeset x1 y1
  (( size = 3 ** n ))
  for (( y=0; y<size; ++y )); do
    y1=$(dc <<<"$y 3op")
    for (( x=0; x<size; ++x )); do
      x1=$(dc <<<"$x 3op")
      if (( 2#${x1//2/0} & 2#${y1//2/0} )); then
        printf ' '
      else
        printf '#'
      fi
    done
    printf '\n'
  done
}
sierpinski_carpet 3
