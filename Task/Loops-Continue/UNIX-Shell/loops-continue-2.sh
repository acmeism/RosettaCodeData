for ((i=1;i<=10;i++)); do
  echo -n $i
  if [ $((i%5)) -eq 0 ]; then
    echo
    continue
  fi
  echo -n ", "
done
