x=1024
while [[ $x -gt 0 ]]; do
  echo $x
  x=$(( $x/2 ))
done
