{
  line[NR] = $0
}
END { # sort it with insertion sort
  for(i=1; i <= NR; i++) {
    value = line[i]
    j = i - 1
    while( ( j > 0) && ( line[j] > value ) ) {
      line[j+1] = line[j]
      j--
    }
    line[j+1] = value
  }
  #print it
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}
