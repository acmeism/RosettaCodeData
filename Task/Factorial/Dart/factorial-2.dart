int fact(int n) {
  if(n<0) {
    throw new IllegalArgumentException('Argument less than 0');
  }
  int res=1;
  for(int i=1;i<=n;i++) {
    res*=i;
  }
  return res;
}

main() {
  print(fact(10));
  print(fact(-1));
}
