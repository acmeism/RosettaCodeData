a=(1 2 3 4 5)
unset e[@]
for ((i=0;i<${#a[@]};i++)); do
  [ $((a[$i]%2)) -eq 0 ] && e[$i]="${a[$i]}"
done
