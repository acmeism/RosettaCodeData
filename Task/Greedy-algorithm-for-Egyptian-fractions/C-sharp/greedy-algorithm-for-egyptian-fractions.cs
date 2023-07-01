using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace EgyptianFractions {
    class Program {
        class Rational : IComparable<Rational>, IComparable<int> {
            public BigInteger Num { get; }
            public BigInteger Den { get; }

            public Rational(BigInteger n, BigInteger d) {
                var c = Gcd(n, d);
                Num = n / c;
                Den = d / c;
                if (Den < 0) {
                    Num = -Num;
                    Den = -Den;
                }
            }

            public Rational(BigInteger n) {
                Num = n;
                Den = 1;
            }

            public override string ToString() {
                if (Den == 1) {
                    return Num.ToString();
                } else {
                    return string.Format("{0}/{1}", Num, Den);
                }
            }

            public Rational Add(Rational rhs) {
                return new Rational(Num * rhs.Den + rhs.Num * Den, Den * rhs.Den);
            }

            public Rational Sub(Rational rhs) {
                return new Rational(Num * rhs.Den - rhs.Num * Den, Den * rhs.Den);
            }

            public int CompareTo(Rational rhs) {
                var ad = Num * rhs.Den;
                var bc = Den * rhs.Num;
                return ad.CompareTo(bc);
            }

            public int CompareTo(int rhs) {
                var ad = Num * rhs;
                var bc = Den * rhs;
                return ad.CompareTo(bc);
            }
        }

        static BigInteger Gcd(BigInteger a, BigInteger b) {
            if (b == 0) {
                if (a < 0) {
                    return -a;
                } else {
                    return a;
                }
            } else {
                return Gcd(b, a % b);
            }
        }

        static List<Rational> Egyptian(Rational r) {
            List<Rational> result = new List<Rational>();

            if (r.CompareTo(1) >= 0) {
                if (r.Den == 1) {
                    result.Add(r);
                    result.Add(new Rational(0));
                    return result;
                }
                result.Add(new Rational(r.Num / r.Den));
                r = r.Sub(result[0]);
            }

            BigInteger modFunc(BigInteger m, BigInteger n) {
                return ((m % n) + n) % n;
            }

            while (r.Num != 1) {
                var q = (r.Den + r.Num - 1) / r.Num;
                result.Add(new Rational(1, q));
                r = new Rational(modFunc(-r.Den, r.Num), r.Den * q);
            }

            result.Add(r);
            return result;
        }

        static string FormatList<T>(IEnumerable<T> col) {
            StringBuilder sb = new StringBuilder();
            var iter = col.GetEnumerator();

            sb.Append('[');
            if (iter.MoveNext()) {
                sb.Append(iter.Current);
            }
            while (iter.MoveNext()) {
                sb.AppendFormat(", {0}", iter.Current);
            }
            sb.Append(']');

            return sb.ToString();
        }

        static void Main() {
            List<Rational> rs = new List<Rational> {
                new Rational(43, 48),
                new Rational(5, 121),
                new Rational(2014, 59)
            };
            foreach (var r in rs) {
                Console.WriteLine("{0} => {1}", r, FormatList(Egyptian(r)));
            }

            var lenMax = Tuple.Create(0UL, new Rational(0));
            var denomMax = Tuple.Create(BigInteger.Zero, new Rational(0));

            var query = (from i in Enumerable.Range(1, 100)
                         from j in Enumerable.Range(1, 100)
                         select new Rational(i, j))
                         .Distinct()
                         .ToList();
            foreach (var r in query) {
                var e = Egyptian(r);
                ulong eLen = (ulong) e.Count;
                var eDenom = e.Last().Den;
                if (eLen > lenMax.Item1) {
                    lenMax = Tuple.Create(eLen, r);
                }
                if (eDenom > denomMax.Item1) {
                    denomMax = Tuple.Create(eDenom, r);
                }
            }

            Console.WriteLine("Term max is {0} with {1} terms", lenMax.Item2, lenMax.Item1);
            var dStr = denomMax.Item1.ToString();
            Console.WriteLine("Denominator max is {0} with {1} digits {2}...{3}", denomMax.Item2, dStr.Length, dStr.Substring(0, 5), dStr.Substring(dStr.Length - 5, 5));
        }
    }
}
