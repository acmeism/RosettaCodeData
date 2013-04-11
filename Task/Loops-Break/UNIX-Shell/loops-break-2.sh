while true; do
  echo $((a=RANDOM%20))
  [ $a -eq 10 ] && break
  echo $((b=RANDOM%20))
done
