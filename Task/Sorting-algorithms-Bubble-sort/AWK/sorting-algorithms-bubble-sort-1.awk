{ # read every line into an array
  line[NR] = $0
}
END { # sort it with bubble sort
  do {
    haschanged = 0
    for(i=1; i < NR; i++) {
      if ( line[i] > line[i+1] ) {
	t = line[i]
	line[i] = line[i+1]
	line[i+1] = t
	haschanged = 1
      }
    }
  } while ( haschanged == 1 )
  # print it
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}
