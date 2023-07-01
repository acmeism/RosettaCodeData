for ((m=0;m<=3;m++)); do
  for ((n=0;n<=6;n++)); do
    ack $m $n
    echo -n " "
  done
  echo
done
