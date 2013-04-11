x=0
while [[ $x < ${#alist[*]} ]]; do
  echo "Item $x = ${alist[$x]}"
  : $((x++))
done
