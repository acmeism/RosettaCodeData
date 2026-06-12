## Intersection: keep in (m) only those also in (x)
function keep(m, x,   i) {
  for (i in m) {
    if (!(i in x)) {
      delete m[i]
    }
  }
}

BEGIN {
  # create sets
  setin(m, "2 5 1 3 8 9 4 6")
  setin(a, "3 5 6 2 9 8 4")
  setin(b, "1 3 7 9 6")
  # do the deed
  keep(m, a)
  keep(m, b)
  # show result
  for (i in m)
    printf( i " " )
  printf( "\n" )
}

# set in array from string
function setin(m, str,  x, i) {
  split(str, x)
  for (i in x)
    m[x[i]] = x[i]    # any value to create element
}
