using System;

namespace PolynomialLongDivision {
    class Solution {
        public Solution(double[] q, double[] r) {
            Quotient = q;
            Remainder = r;
        }

        public double[] Quotient { get; }
        public double[] Remainder { get; }
    }

    class Program {
        static int PolyDegree(double[] p) {
            for (int i = p.Length - 1; i >= 0; --i) {
                if (p[i] != 0.0) return i;
            }
            return int.MinValue;
        }

        static double[] PolyShiftRight(double[] p, int places) {
            if (places <= 0) return p;
            int pd = PolyDegree(p);
            if (pd + places >= p.Length) {
                throw new ArgumentOutOfRangeException("The number of places to be shifted is too large");
            }
            double[] d = new double[p.Length];
            p.CopyTo(d, 0);
            for (int i = pd; i >= 0; --i) {
                d[i + places] = d[i];
                d[i] = 0.0;
            }
            return d;
        }

        static void PolyMultiply(double[] p, double m) {
            for (int i = 0; i < p.Length; ++i) {
                p[i] *= m;
            }
        }

        static void PolySubtract(double[] p, double[] s) {
            for (int i = 0; i < p.Length; ++i) {
                p[i] -= s[i];
            }
        }

        static Solution PolyLongDiv(double[] n, double[] d) {
            if (n.Length != d.Length) {
                throw new ArgumentException("Numerator and denominator vectors must have the same size");
            }
            int nd = PolyDegree(n);
            int dd = PolyDegree(d);
            if (dd < 0) {
                throw new ArgumentException("Divisor must have at least one one-zero coefficient");
            }
            if (nd < dd) {
                throw new ArgumentException("The degree of the divisor cannot exceed that of the numerator");
            }
            double[] n2 = new double[n.Length];
            n.CopyTo(n2, 0);
            double[] q = new double[n.Length];
            while (nd >= dd) {
                double[] d2 = PolyShiftRight(d, nd - dd);
                q[nd - dd] = n2[nd] / d2[nd];
                PolyMultiply(d2, q[nd - dd]);
                PolySubtract(n2, d2);
                nd = PolyDegree(n2);
            }
            return new Solution(q, n2);
        }

        static void PolyShow(double[] p) {
            int pd = PolyDegree(p);
            for (int i = pd; i >= 0; --i) {
                double coeff = p[i];
                if (coeff == 0.0) continue;
                if (coeff == 1.0) {
                    if (i < pd) {
                        Console.Write(" + ");
                    }
                } else if (coeff == -1.0) {
                    if (i < pd) {
                        Console.Write(" - ");
                    } else {
                        Console.Write("-");
                    }
                } else if (coeff < 0.0) {
                    if (i < pd) {
                        Console.Write(" - {0:F1}", -coeff);
                    } else {
                        Console.Write("{0:F1}", coeff);
                    }
                } else {
                    if (i < pd) {
                        Console.Write(" + {0:F1}", coeff);
                    } else {
                        Console.Write("{0:F1}", coeff);
                    }
                }
                if (i > 1) Console.Write("x^{0}", i);
                else if (i == 1) Console.Write("x");
            }
            Console.WriteLine();
        }

        static void Main(string[] args) {
            double[] n = { -42.0, 0.0, -12.0, 1.0 };
            double[] d = { -3.0, 1.0, 0.0, 0.0 };
            Console.Write("Numerator   : ");
            PolyShow(n);
            Console.Write("Denominator : ");
            PolyShow(d);
            Console.WriteLine("-------------------------------------");
            Solution sol = PolyLongDiv(n, d);
            Console.Write("Quotient    : ");
            PolyShow(sol.Quotient);
            Console.Write("Remainder   : ");
            PolyShow(sol.Remainder);
        }
    }
}
