BEGIN {
  # to make an array, assign elements to it
  array[1] = "first"
  array[2] = "second"
  array[3] = "third"
  alen = 3  # want the length? store in separate variable

  # or split a string
  plen = split("2 3 5 7 11 13 17 19 23 29", primes)
  clen = split("Ottawa;Washington DC;Mexico City", cities, ";")

  # retrieve an element
  print "The 6th prime number is " primes[6]

  # push an element
  cities[clen += 1] = "New York"

  dump("An array", array, alen)
  dump("Some primes", primes, plen)
  dump("A list of cities", cities, clen)
}

function dump(what, array, len,    i) {
  print what;

  # iterate an array in order
  for (i = 1; i <= len; i++) {
    print "  " i ": " array[i]
  }
}
