{
  line[NR] = $0
}
END { # sort it with shell sort
  increment = int(NR / 2)
  while ( increment > 0 ) {
    for(i=increment+1; i <= NR; i++) {
      j = i
      temp = line[i]
      while ( (j >= increment+1) && (line[j-increment] > temp) ) {
	line[j] = line[j-increment]
	j -= increment
      }
      line[j] = temp
    }
    if ( increment == 2 )
      increment = 1
    else
      increment = int(increment*5/11)
  }
  #print it
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}
