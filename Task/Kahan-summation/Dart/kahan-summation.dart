double epsilon() {
  double eps = 1.0;
  while (1.0 + eps != 1.0) {
    eps /= 2.0;
  }
  return eps;
}

double kahanSum(List<double> nums) {
  double sum = 0.0;
  double c = 0.0;
  for (var num in nums) {
    double y = num - c;
    double t = sum + y;
    c = (t - sum) - y;
    sum = t;
  }
  return sum;
}

void main() {
  double a = 1.0;
  double b = epsilon();
  double c = -b;

  print("Epsilon     = $b");
  print("(a + b) + c = ${(a + b) + c}");
  print("Kahan sum   = ${kahanSum([a, b, c])}");
  print("Delta       = ${kahanSum([a, b, c]) - (a + b) + c}");
}
