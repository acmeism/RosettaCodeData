using System;

namespace FaulhabersFormula {
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

        static void Faulhaber(int p) {
            Console.Write("{0} : ", p);
            Frac q = new Frac(1, p + 1);
            int sign = -1;
            for (int j = 0; j <= p; j++) {
                sign *= -1;
                Frac coeff = q * new Frac(sign, 1) * new Frac(Binomial(p + 1, j), 1) * Bernoulli(j);
                if (Frac.ZERO == coeff) continue;
                if (j == 0) {
                    if (Frac.ONE != coeff) {
                        if (-Frac.ONE == coeff) {
                            Console.Write("-");
                        }
                        else {
                            Console.Write(coeff);
                        }
                    }
                }
                else {
                    if (Frac.ONE == coeff) {
                        Console.Write(" + ");
                    }
                    else if (-Frac.ONE == coeff) {
                        Console.Write(" - ");
                    }
                    else if (Frac.ZERO < coeff) {
                        Console.Write(" + {0}", coeff);
                    }
                    else {
                        Console.Write(" - {0}", -coeff);
                    }
                }
                int pwr = p + 1 - j;
                if (pwr > 1) {
                    Console.Write("n^{0}", pwr);
                }
                else {
                    Console.Write("n");
                }
            }
            Console.WriteLine();
        }

        static void Main(string[] args) {
            for (int i = 0; i < 10; i++) {
                Faulhaber(i);
            }
        }
    }
}
