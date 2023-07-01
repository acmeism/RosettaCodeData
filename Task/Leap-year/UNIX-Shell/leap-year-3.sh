leap() {
  date -d "$1-02-29" >/dev/null 2>&1;
}
