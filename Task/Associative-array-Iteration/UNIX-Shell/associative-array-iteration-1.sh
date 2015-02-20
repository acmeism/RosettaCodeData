typeset -A a=([key1]=value1 [key2]=value2)

# just keys
printf '%s\n' "${!a[@]}"

# just values
printf '%s\n' "${a[@]}"

# keys and values
for key in "${!a[@]}"; do
	printf '%s => %s\n' "$key" "${a[$key]}"
done
