BEGIN {
  n=10
  for(i=1;i<=n;i++) {
    printf i;
    if(i<n) printf ", "
  }
  print
}
