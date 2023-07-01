function r() {
  return sqrt( -2*log( rand() ) ) * cos(6.2831853*rand() )
}

BEGIN {
  n=1000
  for(i=0;i<n;i++) {
    x = 1 + 0.5*r()
    s = s" "x
  }
  print s
}
