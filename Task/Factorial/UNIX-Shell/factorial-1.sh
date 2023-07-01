factorial() {
  set -- "$1" 1
  until test "$1" -lt 2; do
    set -- "`expr "$1" - 1`" "`expr "$2" \* "$1"`"
  done
  echo "$2"
}
