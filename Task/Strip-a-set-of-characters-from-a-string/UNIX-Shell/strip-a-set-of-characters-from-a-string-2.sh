function strip_chars {
  echo "${1//[$2]}"
}
