double fn(double x) => x * x * x - 3 * x * x + 2 * x;

findRoots(Function(double) f, double start, double stop, double step, double epsilon) sync* {
  for (double x = start; x < stop; x = x + step) {
    if (fn(x).abs() < epsilon) yield x;
  }
}

main() {
  // Vector(-9.381755897326649E-14, 0.9999999999998124, 1.9999999999997022)
  print(findRoots(fn, -1.0, 3.0, 0.0001, 0.000000001));
}
