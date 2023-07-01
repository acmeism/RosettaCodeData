first-digit() {
  printf '%s\n' "${1:0:1}"
}

last-digit() {
  printf '%s\n' $(( $1 % 10 ))
}

bookend-number() {
  printf '%s%s\n' "$(first-digit "$@")" "$(last-digit "$@")"
}

is-gapful() {
  (( $1 >= 100 && $1 % $(bookend-number "$1") == 0 ))
}

gapfuls-in-range() {
  local gapfuls=()
  local -i i found
  for (( i=$1, found=0; found < $2; ++i )); do
    if is-gapful "$i"; then
      if (( found )); then
        printf ' ';
      fi
      printf '%s' "$i"
      (( found++ ))
    fi
  done
  printf '\n'
}

report-ranges() {
  local range
  local -i start size
  for range; do
    IFS=, read start size <<<"$range"
    printf 'The first %d gapful numbers >= %d:\n' "$size" "$start"
    gapfuls-in-range "$start" "$size"
    printf '\n'
  done
}

report-ranges 1,30 1000000,15 1000000000,10
