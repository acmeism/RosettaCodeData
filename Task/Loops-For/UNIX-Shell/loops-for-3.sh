for (( x=1; $x<=5; x=$x+1 )); do
  for (( y=1; y<=$x; y=$y+1 )); do
    echo -n '*'
  done
  echo ""
done
