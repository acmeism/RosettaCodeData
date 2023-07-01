void main() {
  int sum = 0, prod = 1;
  int[] data = { 1, 2, 3, 4 };
  foreach (int val in data) {
    sum  += val;
    prod *= val;
  }
  print(@"sum: $(sum)\nproduct: $(prod)");
}
