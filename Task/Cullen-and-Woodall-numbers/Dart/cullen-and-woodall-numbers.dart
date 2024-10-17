void main() {
  int n, num;
  print("First 20 Cullen numbers:");

  for (n = 1; n <= 20; n++) {
    num = n * (1 << n) + 1;
    print("$num ");
  }

  print("\n\nFirst 20 Woodall numbers:");

  for (n = 1; n <= 20; n++) {
    num = n * (1 << n) - 1;
    print("$num ");
  }
}
