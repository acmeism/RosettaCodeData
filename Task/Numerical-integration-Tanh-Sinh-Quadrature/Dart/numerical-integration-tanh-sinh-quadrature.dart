import 'dart:math';

const double pi = 3.14159265358979323846;

double sinh(double x) => (exp(x) - exp(-x)) / 2.0;
double cosh(double x) => (exp(x) + exp(-x)) / 2.0;
double tanh(double x) => sinh(x) / cosh(x);

double tanhSinh(
  double Function(double) fp,
  double lower,
  double upper,
  int steps,
  double acc,
) {
  double h = 0.1;
  double h0 = (upper - lower) / 2.0;
  double h1 = (lower + upper) / 2.0;
  double rr = 0.0;
  for (int k = 1; k <= steps; ++k) {
    double ro = rr;
    int n = (1 << k) - 1;
    double ss = 0.0;
    for (int i = -n; i <= n; ++i) {
      double t = i * h;
      double sh = sinh(t);
      double ch = cosh(t);
      double th = tanh(sh * pi / 2.0);
      double dx = (ch * pi / 2.0) / pow(cosh(sh * pi / 2.0), 2.0);
      double xi = h1 + h0 * th;
      double wt = h * dx;
      ss += fp(xi) * wt;
    }
    rr = h0 * ss;
    if ((rr - ro).abs() < acc) break;
  }
  return rr;
}

void main() {
  double res = tanhSinh(sin, 0.0, 1.0, 5, 1e-8);
  print(res.toStringAsFixed(8));

  res = tanhSinh(exp, -3.0, 3.0, 5, 1e-8);
  print(res.toStringAsFixed(8));
}
