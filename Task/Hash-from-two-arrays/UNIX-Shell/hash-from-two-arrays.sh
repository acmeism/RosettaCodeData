keys=( foo bar baz )
values=( 123 456 789 )
declare -A hash

for (( i = 0; i < ${#keys[@]}; i++ )); do
  hash["${keys[i]}"]=${values[i]}
done

for key in "${!hash[@]}"; do
  printf "%s => %s\n" "$key" "${hash[$key]}"
done
