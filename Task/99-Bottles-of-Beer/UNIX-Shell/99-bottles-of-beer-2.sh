bottles() {
  beer=$1
  [ $((beer)) -gt 0 ] && echo -n $beer ||  echo -n "No more"
  echo -n " bottle"
  [ $((beer)) -ne 1 ] && echo -n "s"
  echo -n " of beer"
}

for ((i=99;i>=0;i--)); do
  ((remaining=i))
  echo "$(bottles $remaining) on the wall"
  echo "$(bottles $remaining)"
  if [ $((remaining)) -eq 0 ]; then
    echo "Go to the store and buy some more"
    ((remaining+=99))
  else
    echo "Take one down, pass it around"
    ((remaining--))
  fi
  echo "$(bottles $remaining) on the wall"
  echo
done
