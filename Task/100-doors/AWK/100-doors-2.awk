BEGIN {
  for(i=1; i <= 100; i++) {
    doors[i] = 0 # close the doors
  }
  for(i=1; i <= 100; i++) {
    if ( int(sqrt(i)) == sqrt(i) ) {
      doors[i] = 1
    }
  }
  for(i=1; i <= 100; i++)
  {
    print i, doors[i] ? "open" : "close"
  }
}
