BEGIN {
  v = 1024
  while(v > 0) {
    print v
    v = int(v/2)
  }
}
