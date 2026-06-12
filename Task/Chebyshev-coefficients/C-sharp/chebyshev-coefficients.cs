using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chebyshev {
    class Program {
        struct ChebyshevApprox {
            public readonly List<double> coeffs;
            public readonly Tuple<double, double> domain;

            public ChebyshevApprox(Func<double, double> func, int n, Tuple<double, double> domain) {
                coeffs = ChebCoef(func, n, domain);
                this.domain = domain;
            }

            public double Call(double x) {
                return ChebEval(coeffs, domain, x);
            }
        }

        static double AffineRemap(Tuple<double, double> from, double x, Tuple<double, double> to) {
            return to.Item1 + (x - from.Item1) * (to.Item2 - to.Item1) / (from.Item2 - from.Item1);
        }

        static List<double> ChebCoef(List<double> fVals) {
            int n = fVals.Count;
            double theta = Math.PI / n;
            List<double> retval = new List<double>();
            for (int i = 0; i < n; i++) {
                retval.Add(0.0);
            }
            for (int ii = 0; ii < n; ii++) {
                double f = fVals[ii] * 2.0 / n;
                double phi = (ii + 0.5) * theta;
                double c1 = Math.Cos(phi);
                double s1 = Math.Sin(phi);
                double c = 1.0;
                double s = 0.0;
                for (int j = 0; j < n; j++) {
                    retval[j] += f * c;
                    // update c -> cos(j*phi) for next value of j
                    double cNext = c * c1 - s * s1;
                    s = c * s1 + s * c1;
                    c = cNext;
                }
            }
            return retval;
        }

        static List<double> ChebCoef(Func<double, double> func, int n, Tuple<double, double> domain) {
            double remap(double x) {
                return AffineRemap(new Tuple<double, double>(-1.0, 1.0), x, domain);
            }
            double theta = Math.PI / n;
            List<double> fVals = new List<double>();
            for (int i = 0; i < n; i++) {
                fVals.Add(0.0);
            }
            for (int ii = 0; ii < n; ii++) {
                fVals[ii] = func(remap(Math.Cos((ii + 0.5) * theta)));
            }
            return ChebCoef(fVals);
        }

        static double ChebEval(List<double> coef, double x) {
            double a = 1.0;
            double b = x;
            double c;
            double retval = 0.5 * coef[0] + b * coef[1];
            var it = coef.GetEnumerator();
            it.MoveNext();
            it.MoveNext();
            while (it.MoveNext()) {
                double pc = it.Current;
                c = 2.0 * b * x - a;
                retval += pc * c;
                a = b;
                b = c;
            }
            return retval;
        }

        static double ChebEval(List<double> coef, Tuple<double, double> domain, double x) {
            return ChebEval(coef, AffineRemap(domain, x, new Tuple<double, double>(-1.0, 1.0)));
        }

        static void Main() {
            const int N = 10;
            ChebyshevApprox fApprox = new ChebyshevApprox(Math.Cos, N, new Tuple<double, double>(0.0, 1.0));
            Console.WriteLine("Coefficients: ");
            foreach (var c in fApprox.coeffs) {
                Console.WriteLine("\t{0: 0.00000000000000;-0.00000000000000;zero}", c);
            }

            Console.WriteLine("\nApproximation:\n    x       func(x)        approx      diff");
            const int nX = 20;
            const int min = 0;
            const int max = 1;
            for (int i = 0; i < nX; i++) {
                double x = AffineRemap(new Tuple<double, double>(0, nX), i, new Tuple<double, double>(min, max));
                double f = Math.Cos(x);
                double approx = fApprox.Call(x);
                Console.WriteLine("{0:0.000} {1:0.00000000000000} {2:0.00000000000000} {3:E}", x, f, approx, approx - f);
            }
        }
    }
}
