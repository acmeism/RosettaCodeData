possible=
i=0
while [ $i -lt 18 ]; do
  j=0
  while [ $j -lt 13 ]; do
    k=0
    while [ $k -lt 6 ]; do
      possible="${possible+$possible }"`expr $i \* 6 + $j \* 9 + $k \* 20`
      k=`expr $k + 1`
    done
    j=`expr $j + 1`
  done
  i=`expr $i + 1`
done

n=100
while [ $n -gt 0 ]; do
  if echo "$possible" | tr ' ' '\n' | fgrep -qx $n; then
    n=`expr $n - 1`
    continue
  fi
  break
done
echo "Maximum non-McNuggets number is $n"
