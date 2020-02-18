void main() {
  const int N = 15;
  uint64[] t = {0, 1};
  for (int i = 1; i <= N; i++) {
    for (int j = i; j > 1; j--) t[j] = t[j] + t[j - 1];
    t[i + 1] = t[i];
    for (int j = i + 1; j > 1; j--) t[j] = t[j] + t[j - 1];
    print(@"$(t[i + 1] - t[i]) ");
  }
  print("\n");
}
