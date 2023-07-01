num=0
while test 0 -le $num; do
  printf '%o\n' $num
  num=$((num + 1))
done
