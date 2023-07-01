size=10

for ((i=0;i<size;i++)); do
  unset t[@]
  for ((j=0;j<size;j++)); do
    t[$j]=$((RANDOM%20+1))
  done
  a[$i]="${t[*]}"
done

for ((i=0;i<size;i++)); do
  t=(${a[$i]})
  for ((j=0;j<size;j++)); do
    printf "%2d " ${t[$j]}
    [ ${t[$j]} -eq 20 ] && break 2
  done
  echo
done
echo
