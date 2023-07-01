list=(these are some words)
printf '%s\n' "$list[RANDOM%$#list+1]"
