int fact(int n) {
  if(n<0) {
    throw new IllegalArgumentException('Argument less than 0');
  }
  return n==0 ? 1 : n*fact(n-1);
}

main() {
  print(fact(10));
  print(fact(-1));
}
