using System;

namespace FaulhabersTriangle {
    internal class Frac {
        private long num;
        private long denom;

        public static readonly Frac ZERO = new Frac(0, 1);
        public static readonly Frac ONE = new Frac(1, 1);

        public Frac(long n, long d) {
            if (d == 0) {
                throw new ArgumentException("d must not be zero");
            }
            long nn = n;
            long dd = d;
            if (nn == 0) {
                dd = 1;
            }
            else if (dd < 0) {
                nn = -nn;
                dd = -dd;
            }
            long g = Math.Abs(Gcd(nn, dd));
            if (g > 1) {
                nn /= g;
                dd /= g;
            }
            num = nn;
            denom = dd;
        }

        private static long Gcd(long a, long b) {
            if (b == 0) {
                return a;
            }
            return Gcd(b, a % b);
        }

        public static Frac operator -(Frac self) {
            return new Frac(-self.num, self.denom);
        }

        public static Frac operator +(Frac lhs, Frac rhs) {
            return new Frac(lhs.num * rhs.denom + lhs.denom * rhs.num, rhs.denom * lhs.denom);
        }

        public static Frac operator -(Frac lhs, Frac rhs) {
            return lhs + -rhs;
        }

        public static Frac operator *(Frac lhs, Frac rhs) {
            return new Frac(lhs.num * rhs.num, lhs.denom * rhs.denom);
        }

        public static bool operator <(Frac lhs, Frac rhs) {
            double x = (double)lhs.num / lhs.denom;
            double y = (double)rhs.num / rhs.denom;
            return x < y;
        }

        public static bool operator >(Frac lhs, Frac rhs) {
            double x = (double)lhs.num / lhs.denom;
            double y = (double)rhs.num / rhs.denom;
            return x > y;
        }

        public static bool operator ==(Frac lhs, Frac rhs) {
            return lhs.num == rhs.num && lhs.denom == rhs.denom;
        }

        public static bool operator !=(Frac lhs, Frac rhs) {
            return lhs.num != rhs.num || lhs.denom != rhs.denom;
        }

        public override string ToString() {
            if (denom == 1) {
                return num.ToString();
            }
            return string.Format("{0}/{1}", num, denom);
        }

        public override bool Equals(object obj) {
            var frac = obj as Frac;
            return frac != null &&
                   num == frac.num &&
                   denom == frac.denom;
        }

        public override int GetHashCode() {
            var hashCode = 1317992671;
            hashCode = hashCode * -1521134295 + num.GetHashCode();
            hashCode = hashCode * -1521134295 + denom.GetHashCode();
            return hashCode;
        }
    }

    class Program {
        static Frac Bernoulli(int n) {
            if (n < 0) {
                throw new ArgumentException("n may not be negative or zero");
            }
            Frac[] a = new Frac[n + 1];
            for (int m = 0; m <= n; m++) {
                a[m] = new Frac(1, m + 1);
                for (int j = m; j >= 1; j--) {
                    a[j - 1] = (a[j - 1] - a[j]) * new Frac(j, 1);
                }
            }
            // returns 'first' Bernoulli number
            if (n != 1) return a[0];
            return -a[0];
        }

        static int Binomial(int n, int k) {
            if (n < 0 || k < 0 || n < k) {
                throw new ArgumentException();
            }
            if (n == 0 || k == 0) return 1;
            int num = 1;
            for (int i = k + 1; i <= n; i++) {
                num = num * i;
            }
            int denom = 1;
            for (int i = 2; i <= n - k; i++) {
                denom = denom * i;
            }
            return num / denom;
        }

        static Frac[] FaulhaberTriangle(int p) {
            Frac[] coeffs = new Frac[p + 1];
            for (int i = 0; i < p + 1; i++) {
                coeffs[i] = Frac.ZERO;
            }
            Frac q = new Frac(1, p + 1);
            int sign = -1;
            for (int j = 0; j <= p; j++) {
                sign *= -1;
                coeffs[p - j] = q * new Frac(sign, 1) * new Frac(Binomial(p + 1, j), 1) * Bernoulli(j);
            }
            return coeffs;
        }

        static void Main(string[] args) {
            for (int i = 0; i < 10; i++) {
                Frac[] coeffs = FaulhaberTriangle(i);
                foreach (Frac coeff in coeffs) {
                    Console.Write("{0,5}  ", coeff);
                }
                Console.WriteLine();
            }
        }
    }
}
