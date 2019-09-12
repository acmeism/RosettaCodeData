isprime(n) {
  auto p;
  if(n<2) return(0);
  if(!(n%2)) return(n==2);
  p=3;
  while(n/p>p) {
    if(!(n%p)) return(0);
    p=p+2;
  }
  return(1);
}
