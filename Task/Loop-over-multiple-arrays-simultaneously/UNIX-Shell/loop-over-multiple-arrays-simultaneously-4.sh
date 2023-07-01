set -A a a b c
set -A b A B C
set -A c 1 2 3
((i = 0))
while ((i < ${#a[@]})); do
  echo "${a[$i]}${b[$i]}${c[$i]}"
  ((i++))
done
