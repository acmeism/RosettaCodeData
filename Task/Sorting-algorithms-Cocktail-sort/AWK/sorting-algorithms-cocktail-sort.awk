{
  line[NR] = $0
}
END { # sort it with cocktail sort
  swapped = 0
  do {
    for(i=1; i < NR; i++) {
      if ( line[i] > line[i+1] ) {
	t = line[i]
	line[i] = line[i+1]
	line[i+1] = t
	swapped = 1
      }
    }
    if ( swapped == 0 ) break
    swapped = 0
    for(i=NR-1; i >= 1; i--) {
      if ( line[i] > line[i+1] ) {
	t = line[i]
	line[i] = line[i+1]
	line[i+1] = t
	swapped = 1
      }
    }
  } while ( swapped == 1 )
  #print it
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}
