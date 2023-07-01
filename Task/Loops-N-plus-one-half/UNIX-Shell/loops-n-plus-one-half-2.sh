for ((i=1;i<=$((last=10));i++)); do
  echo -n $i
  [ $i -eq $last ] && break
  echo -n ", "
done
