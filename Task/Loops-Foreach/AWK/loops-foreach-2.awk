BEGIN {
  n = split("Mary had a little lamb", strs, " ")
  for(i=1; i <= n; i++) {
    print strs[i]
  }
}
