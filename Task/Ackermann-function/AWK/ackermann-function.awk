function ackermann(m, n)
{
  if ( m == 0 ) {
    return n+1
  }
  if ( n == 0 ) {
    return ackermann(m-1, 1)
  }
  return ackermann(m-1, ackermann(m, n-1))
}

BEGIN {
  for(n=0; n < 7; n++) {
    for(m=0; m < 4; m++) {
      print "A(" m "," n ") = " ackermann(m,n)
    }
  }
}
