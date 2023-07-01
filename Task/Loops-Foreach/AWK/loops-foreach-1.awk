BEGIN {
  split("Mary had a little lamb", strs, " ")
  for(el in strs) {
    print strs[el]
  }
}
