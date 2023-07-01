a=1
b=0
printf '%d and %d = %d\n' "$a" "$b" "$(( a && b ))"
printf '%d or %d = %d\n' "$a" "$b" "$(( a || b ))"
printf 'not %d = %d\n' "$a" "$(( ! a ))"
