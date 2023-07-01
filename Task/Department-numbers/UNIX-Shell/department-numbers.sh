function main {
  set -- Police Sanitation Fire
  typeset -i pw=${#1} sw=${#2} fw=${#3}
  printf '%s' "$1"
  shift
  printf '\t%s' "$@"
  printf '\n'
  for (( p=2; p<8; p+=2 )); do
    for (( s=1; s<8; ++s )); do
      if (( s == p )); then
        continue
      fi
      (( f = 12 - p - s ))
      if (( f == s || f == p || f < 1 || f > 7 )); then
        continue
      fi
      printf "%${pw}d\t%${sw}d\t%${fw}d\n" "$p" "$s" "$f"
    done
  done
}

main "$@"
