function fact_r(n)
{
  if ( n <= 1 ) return 1;
  return n*fact_r(n-1);
}
