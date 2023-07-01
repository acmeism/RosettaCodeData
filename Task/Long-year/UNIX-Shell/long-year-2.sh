long_year() {
  expr $(date -d "$1-12-28" +%V) = 53 >/dev/null
}
