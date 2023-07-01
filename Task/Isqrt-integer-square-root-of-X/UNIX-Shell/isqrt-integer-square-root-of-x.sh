function isqrt {
  typeset -i x
  for x; do
    typeset -i q=1
    while (( q <= x )); do
      (( q <<= 2 ))
      if (( q <= 0 )); then
        return 1
      fi
    done
    typeset -i z=x
    typeset -i r=0
    typeset -i t
    while (( q > 1 )); do
      (( q >>= 2 ))
      (( t = z - r - q ))
      (( r >>= 1 ))
      if (( t >= 0 )); then
        (( z = t ))
        (( r = r + q ))
      fi
    done
    printf '%d\n' "$r"
  done
}

# demo
printf 'isqrt(n) for n from 0 to 65:\n'
for i in {1..4}; do
  for n in {0..65}; do
    case $i in
     1)
      (( tens=n/10 ))
      if (( tens )); then
        printf '%2d' "$tens"
      else
        printf '  '
      fi
      ;;
     2) printf '%2d' $(( n%10 ));;
     3) printf -- '--';;
     4) printf '%2d' "$(isqrt "$n")";;
    esac
  done
  printf '\n'
done
printf '\n'

printf 'isqrt(7ⁿ) for odd n up to the limit of integer precision:\n'
printf '%2s|%27sⁿ|%14sⁿ)\n' "n" "7" "isqrt(7"
for (( i=0;i<48; ++i )); do printf '-'; done; printf '\n'
for (( p=1; p<=73 && (n=7**p) > 0; p+=2)); do
  if r=$(isqrt $n); then
    printf "%2d|%'28d|%'16d\n" "$p" "$n" "$r"
  else
    break
  fi
done
