nth() {
  local ordinals=(th st nd rd)
  local -i n=$1 i
  if (( n < 0 )); then
    printf '%s%s\n' - "$(nth $(( -n )) )"
    return 0
  fi
  case $(( n % 100 )) in
    11|12|13) i=0;;
    *) (( i= n%10 < 4 ? n%10 : 0 ));;
  esac
  printf '%d%s\n' "$n" "${ordinals[i]}"
}
for n in {0..25} {250..265} {1000..1025}; do
  nth $n
done | column
