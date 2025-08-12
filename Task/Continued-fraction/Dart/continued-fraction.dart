void main() {
  List<Function> fList = [
    (int n) => [n > 0 ? 2 : 1, 1],
    (int n) => [n > 0 ? n : 2, n > 1 ? (n - 1) : 1],
    (int n) => [n > 0 ? 6 : 3, (2 * n - 1) * (2 * n - 1)],
  ];

  for (var f in fList) {
    print(calc(f, 200));
  }
}

double calc(Function f, int n) {
  double temp = 0;
  for (int ni = n; ni >= 1; ni--) {
    List<int> p = f(ni);
    temp = p[1] / (p[0] + temp);
  }
  return f(0)[0] + temp;
}
