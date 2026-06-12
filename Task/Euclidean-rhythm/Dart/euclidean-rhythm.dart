List<int> E(int k, int n) {
  List<List<int>> s = List.generate(n, (i) => i < k ? [1] : [0]);

  int d = n - k;
  n = k > d ? k : d;
  k = k < d ? k : d;
  int z = d;

  while (z > 0 || k > 1) {
    for (int i = 0; i < k; i++) {
      s[i].addAll(s[s.length - 1 - i]);
    }
    s = s.sublist(0, s.length - k);
    z -= k;
    d = n - k;
    n = k > d ? k : d;
    k = k < d ? k : d;
  }

  return s.expand((sublist) => sublist).toList();
}

void main() {
  print(E(5, 13).join());
  // Expected output: 1001010010100
}
