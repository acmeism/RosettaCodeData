# usage:  awk -v x=9  -f test.awk
BEGIN {
  y = 3
  z = x+y
  print "x,y,z:", x,y,z
  printf( "x=%d,y=%d,z=%d:", x,y,z )
}
