x=${#alist[*]}       # start with the number of items in the array
while [[ $x > 0 ]]; do     # while there are items left
  : $((x--))               # decrement first, because indexing is zero-based
  echo "Item $x = ${alist[$x]}"   # show the current item
done
