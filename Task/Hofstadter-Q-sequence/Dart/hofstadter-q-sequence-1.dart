int Q(int n) => n>2 ? Q(n-Q(n-1))+Q(n-Q(n-2)) : 1;

main() {
  for(int i=1;i<=10;i++) {
    print("Q($i)=${Q(i)}");
  }
  print("Q(1000)=${Q(1000)}");
}
