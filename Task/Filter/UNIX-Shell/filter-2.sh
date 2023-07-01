a=(1 2 3 4 5)
read -a e -d\n < <(printf '%s\n' "${a[@]}" | grep '[02468]$')
