a=(a b c)
b=(A B C)
c=(1 2 3)
for ((i = 0; i < ${#a[@]}; i++)); do
  echo "${a[$i]}${b[$i]}${c[$i]}"
done
