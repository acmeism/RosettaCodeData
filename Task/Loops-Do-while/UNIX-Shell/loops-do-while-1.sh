val=0
while true; do
  echo $((++val))
  [ $((val%6)) -eq 0 ] && break
done
