val=0
while true; do
  val=`expr $val + 1`
  echo $val
  expr $val % 6 = 0 >/dev/null && break
done
