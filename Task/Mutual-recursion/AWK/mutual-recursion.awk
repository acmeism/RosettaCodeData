function F(n)
{
  if ( n == 0 ) return 1;
  return n - M(F(n-1))
}

function M(n)
{
  if ( n == 0 ) return 0;
  return n - F(M(n-1))
}

BEGIN {
  for(i=0; i < 20; i++) {
    printf "%3d ", F(i)
  }
  print ""
  for(i=0; i < 20; i++) {
    printf "%3d ", M(i)
  }
  print ""
}
