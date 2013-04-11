BEGIN {
  while ( (getline <"input.txt") > 0 ) {
    print >"output.txt"
  }
}
