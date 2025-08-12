keys=( foo bar baz )
values=( 123 456 789 )
declare -A hash

for i in {1..$#keys}; do
  hash[$keys[i]]=$values[i]
done

printf '%s => %s\n' "${(kv@)hash}"
