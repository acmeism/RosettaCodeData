void main() {
  const double EPSILON = 1.0e-15;
  double fact = 1;
  double e = 2.0, e0;
  int n = 2;
  do {
    e0 = e;
    fact *= n++;
    e += 1.0 / fact;
  } while ((e-e0).abs() >= EPSILON);
  print('The value of e = $e');
}
