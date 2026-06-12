// Numerical integration/Adaptive Simpson's method
using System;

class Program
{
  delegate double FD2DDelegate(double x);

  private static void SimpsonRule(FD2DDelegate f,
                                  double a, double fa,
                                  double b, double fb,
                                  out double m, out double fm,
                                  out double quadVal)
  {
    m = (a + b) / 2;
    fm = f(m);
    quadVal = ((b - a) / 6) * (fa + (4 * fm) + fb);
  }

  private static double Recursion(FD2DDelegate f,
                                  double a, double fa,
                                  double b, double fb,
                                  double tol,
                                  double whole,
                                  double m, double fm,
                                  int depth)
  {
    double lm, flm, left;
    double rm, frm, right;
    double delta, tol2;
    SimpsonRule(f, a, fa, m, fm, out lm, out flm, out left);
    SimpsonRule(f, m, fm, b, fb, out rm, out frm, out right);
    delta = left + right - whole;
    tol2 = tol / 2;
    if (depth <= 0 || tol2 == tol || Math.Abs(delta) <= 15 * tol)
      return left + right + (delta / 15);
    else
      return
          Recursion(f, a, fa, m, fm, tol2, left , lm, flm, depth - 1) +
          Recursion(f, m, fm, b, fb, tol2, right, rm, frm, depth - 1);
  }

  static double QuadASR(FD2DDelegate f,
                        double a,
                        double b,
                        double tol,
                        int depth)
  {
    double fa, fb, m, fm, whole;
    fa = f(a);
    fb = f(b);
    SimpsonRule(f, a, fa, b, fb, out m, out fm, out whole);
    return Recursion(f, a, fa, b, fb, tol, whole, m, fm, depth);
  }

  static void Main()
  {
    double q = QuadASR(Math.Sin, 0, 1, 0.000000001, 1000);
    Console.Write("Estimated definite integral of sin(x) ");
    Console.WriteLine("for x from 0 to 1: {0,11:N8}", q);
  }
}
