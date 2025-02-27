horner()
  if
    local -i x=$1
    shift
    (($#))
  then
    local -i y=$1
    shift
    echo $((y + x*$( horner $x "$@") ))
  else echo 0
  fi

horner 3 -19 7 -4 6
