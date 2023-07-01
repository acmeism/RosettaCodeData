long_year() {
  cal 1 $1 | grep -q ' 3 *$' && return 0
  cal 12 $1 | grep -q ' 26 *$'
}
