function main {
  typeset attrs=(str dex con int wis cha)
  typeset -A values
  typeset attr
  typeset -i value total fifteens
  while true; do
    fifteens=0
    total=0
    for attr in "${attrs[@]}"; do
      # "random" values repeat in zsh if run in a subshell
      r4d6drop >/tmp/$$
      read value </tmp/$$
      values[$attr]=$value
      (( total += value ))
      if (( value >= 15 )); then
        (( fifteens += 1 ))
      fi
    done
    if (( total >= 75 && fifteens >= 2 )); then
      break
    fi
  done
  rm -f /tmp/$$
  for attr in "${attrs[@]}"; do
    printf '%s: %d\n' "$attr" "${values[$attr]}"
  done
}

function r4d6drop {
   typeset -i d1=RANDOM%6+1 d2=RANDOM%6+1 d3=RANDOM%6+1 d4=RANDOM%6+1
   typeset e=$(printf '%s\n' $d1 $d2 $d3 $d4 |
     sort -n | tail -n +2 | tr $'\n' +)
  printf '%d\n' $(( ${e%+} ))
}

main "$@"
