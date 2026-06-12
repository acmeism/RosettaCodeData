void main() {
  const int n = 2000;

  List<int> dcount = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0];

  List<int> v = List<int>.filled(n, 1);

  // Main calculation loop
  for (int col = 0; col <= 2 * n; col++) {
    int a = n + 1;
    int c = 0;

    for (int i = 0; i < n; i++) {
      c += v[i] * 10;
      v[i] = c % a;
      c = c ~/ a;
      a -= 1;
    }

    dcount[c]++;
  }

  print(dcount.join(' '));
}
