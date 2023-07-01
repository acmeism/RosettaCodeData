using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IntMap = System.Collections.Generic.Dictionary<int, int>;

public static class CyclotomicPolynomial
{
    public static void Main2() {
        Console.WriteLine("Task 1: Cyclotomic polynomials for n <= 30:");
        for (int i = 1; i <= 30; i++) {
            var p = GetCyclotomicPolynomial(i);
            Console.WriteLine($"CP[{i}] = {p.ToString()}");
        }
        Console.WriteLine();

        Console.WriteLine("Task 2: Smallest cyclotomic polynomial with n or -n as a coefficient:");
        for (int i = 1, n = 0; i <= 10; i++) {
            while (true) {
                n++;
                var p = GetCyclotomicPolynomial(n);
                if (p.Any(t => Math.Abs(t.Coefficient) == i)) {
                    Console.WriteLine($"CP[{n}] has coefficient with magnitude = {i}");
                    n--;
                    break;
                }
            }
        }
    }

    private const int MaxFactors = 100_000;
    private const int Algorithm = 2;
    private static readonly Term x = new Term(1, 1);
    private static readonly Dictionary<int, Polynomial> polyCache =
        new Dictionary<int, Polynomial> { [1] = x - 1 };
    private static readonly Dictionary<int, IntMap> factorCache =
        new Dictionary<int, IntMap> { [2] = new IntMap { [2] = 1 } };

    private static Polynomial GetCyclotomicPolynomial(in int n) {
        if (polyCache.TryGetValue(n, out var result)) return result;

        var factors = GetFactors(n);
        if (factors.ContainsKey(n)) { //n is prime
            result = new Polynomial(from exp in ..n select x[exp]);
        } else if (factors.Count == 2 && factors.Contains(2, 1) && factors.Contains(n/2, 1)) { //n = 2p
            result = new Polynomial(from i in ..(n/2) select (IsOdd(i) ? -x : x)[i]);
        } else if (factors.Count == 1 && factors.TryGetValue(2, out int h)) { //n = 2^h
            result = x[1<<(h-1)] + 1;
        } else if (factors.Count == 1 && !factors.ContainsKey(n)) { // n = p^k
            (int p, int k) = factors.First();
            result = new Polynomial(from i in ..p select x[i * (int)Math.Pow(p, k-1)]);
        } else if (factors.Count == 2 && factors.ContainsKey(2)) { //n = 2^h * p^k
            (int p, int k) = factors.First(entry => entry.Key != 2);
            int twoExp = 1 << (factors[2] - 1);
            result = new Polynomial(from i in ..p select (IsOdd(i) ? -x : x)[i * twoExp * (int)Math.Pow(p, k-1)]);
        } else if (factors.ContainsKey(2) && IsOdd(n/2) && n/2 > 1) { // CP(2m)[x] = CP[-m][x], n is odd > 1
            Polynomial cycloDiv2 = GetCyclotomicPolynomial(n/2);
            result = new Polynomial(from term in cycloDiv2 select IsOdd(term.Exponent) ? -term : term);
            #pragma warning disable CS0162
        } else if (Algorithm == 0) {
            var divisors = GetDivisors(n);
            result = x[n] - 1;
            foreach (int d in divisors) result /= GetCyclotomicPolynomial(d);
        } else if (Algorithm == 1) {
            var divisors = GetDivisors(n).ToList();
            int maxDivisor = divisors.Max();
            result = (x[n] - 1) / (x[maxDivisor] - 1);
            foreach (int d in divisors.Where(div => maxDivisor % div == 0)) {
                result /= GetCyclotomicPolynomial(d);
            }
        } else if (Algorithm == 2) {
            int m = 1;
            result = GetCyclotomicPolynomial(m);
            var primes = factors.Keys.ToList();
            primes.Sort();
            foreach (int prime in primes) {
                var cycloM = result;
                result = new Polynomial(from term in cycloM select term.Coefficient * x[term.Exponent * prime]);
                result /= cycloM;
                m *= prime;
            }
            int s = n / m;
            result = new Polynomial(from term in result select term.Coefficient * x[term.Exponent * s]);
            #pragma warning restore CS0162
        } else {
            throw new InvalidOperationException("Invalid algorithm");
        }
        polyCache[n] = result;
        return result;
    }

    private static bool IsOdd(int i) => (i & 1) != 0;
    private static bool Contains(this IntMap map, int key, int value) => map.TryGetValue(key, out int v) && v == value;
    private static int GetOrZero(this IntMap map, int key) => map.TryGetValue(key, out int v) ? v : 0;
    private static IEnumerable<T> Select<T>(this Range r, Func<int, T> f) => Enumerable.Range(r.Start.Value, r.End.Value - r.Start.Value).Select(f);

    private static IntMap GetFactors(in int n) {
        if (factorCache.TryGetValue(n, out var factors)) return factors;

        factors = new IntMap();
        if (!IsOdd(n)) {
            foreach (var entry in GetFactors(n/2)) factors.Add(entry.Key, entry.Value);
            factors[2] = factors.GetOrZero(2) + 1;
            return Cache(n, factors);
        }
        for (int i = 3; i * i <= n; i+=2) {
            if (n % i == 0) {
                foreach (var entry in GetFactors(n/i)) factors.Add(entry.Key, entry.Value);
                factors[i] = factors.GetOrZero(i) + 1;
                return Cache(n, factors);
            }
        }
        factors[n] = 1;
        return Cache(n, factors);
    }

    private static IntMap Cache(int n, IntMap factors) {
        if (n < MaxFactors) factorCache[n] = factors;
        return factors;
    }

    private static IEnumerable<int> GetDivisors(int n) {
        for (int i = 1; i * i <= n; i++) {
            if (n % i == 0) {
                yield return i;
                int div = n / i;
                if (div != i && div != n) yield return div;
            }
        }
    }

    public sealed class Polynomial : IEnumerable<Term>
    {
        public Polynomial() { }
        public Polynomial(params Term[] terms) : this(terms.AsEnumerable()) { }

        public Polynomial(IEnumerable<Term> terms) {
            Terms.AddRange(terms);
            Simplify();
        }

        private List<Term>? terms;
        private List<Term> Terms => terms ??= new List<Term>();

        public int Count => terms?.Count ?? 0;
        public int Degree => Count == 0 ? -1 : Terms[0].Exponent;
        public int LeadingCoefficient => Count == 0 ? 0 : Terms[0].Coefficient;

        public IEnumerator<Term> GetEnumerator() => Terms.GetEnumerator();
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

        public override string ToString() => Count == 0 ? "0" : string.Join(" + ", Terms).Replace("+ -", "- ");

        public static Polynomial operator *(Polynomial p, Term t) => new Polynomial(from s in p select s * t);
        public static Polynomial operator +(Polynomial p, Polynomial q) => new Polynomial(p.Terms.Concat(q.Terms));
        public static Polynomial operator -(Polynomial p, Polynomial q) => new Polynomial(p.Terms.Concat(q.Terms.Select(t => -t)));
        public static Polynomial operator *(Polynomial p, Polynomial q) => new Polynomial(from s in p from t in q select s * t);
        public static Polynomial operator /(Polynomial p, Polynomial q) => p.Divide(q).quotient;

        public (Polynomial quotient, Polynomial remainder) Divide(Polynomial divisor) {
            if (Degree < 0) return (new Polynomial(), this);
            Polynomial quotient = new Polynomial();
            Polynomial remainder = this;
            int lcv = divisor.LeadingCoefficient;
            int dv = divisor.Degree;
            while (remainder.Degree >= divisor.Degree) {
                int lcr = remainder.LeadingCoefficient;
                Term div = new Term(lcr / lcv, remainder.Degree - dv);
                quotient.Terms.Add(div);
                remainder += divisor * -div;
            }
            quotient.Simplify();
            remainder.Simplify();
            return (quotient, remainder);
        }

        private void Simplify() {
            if (Count < 2) return;
            Terms.Sort((a, b) => -a.CompareTo(b));
            for (int i = Terms.Count - 1; i > 0; i--) {
                Term s = Terms[i-1];
                Term t = Terms[i];
                if (t.Exponent == s.Exponent) {
                    Terms[i-1] = new Term(s.Coefficient + t.Coefficient, s.Exponent);
                    Terms.RemoveAt(i);
                }
            }
            Terms.RemoveAll(t => t.IsZero);
        }

    }

    public readonly struct Term : IEquatable<Term>, IComparable<Term>
    {
        public Term(int coefficient, int exponent = 0) => (Coefficient, Exponent) = (coefficient, exponent);

        public Term this[int exponent] => new Term(Coefficient, exponent); //Using x[exp] because x^exp has low precedence
        public int Coefficient { get; }
        public int Exponent { get; }
        public bool IsZero => Coefficient == 0;

        public static Polynomial operator +(Term left, Term right) => new Polynomial(left, right);
        public static Polynomial operator -(Term left, Term right) => new Polynomial(left, -right);
        public static implicit operator Term(int coefficient) => new Term(coefficient);
        public static Term operator -(Term t) => new Term(-t.Coefficient, t.Exponent);
        public static Term operator *(Term left, Term right) => new Term(left.Coefficient * right.Coefficient, left.Exponent + right.Exponent);

        public static bool operator ==(Term left, Term right) => left.Equals(right);
        public static bool operator !=(Term left, Term right) => !left.Equals(right);
        public static bool operator  <(Term left, Term right) => left.CompareTo(right)  < 0;
        public static bool operator  >(Term left, Term right) => left.CompareTo(right)  > 0;
        public static bool operator <=(Term left, Term right) => left.CompareTo(right) <= 0;
        public static bool operator >=(Term left, Term right) => left.CompareTo(right) >= 0;

        public bool Equals(Term other) => Exponent == other.Exponent && Coefficient == other.Coefficient;
        public override bool Equals(object? obj) => obj is Term t && Equals(t);
        public override int GetHashCode() => Coefficient.GetHashCode() * 31 + Exponent.GetHashCode();

        public int CompareTo(Term other) {
            int c = Exponent.CompareTo(other.Exponent);
            if (c != 0) return c;
            return Coefficient.CompareTo(other.Coefficient);
        }

        public override string ToString() => (Coefficient, Exponent) switch {
            (0,  _) => "0",
            (_,  0) => $"{Coefficient}",
            (1,  1) => "x",
            (-1, 1) => "-x",
            (_,  1) => $"{Coefficient}x",
            (1,  _) => $"x^{Exponent}",
            (-1, _) => $"-x^{Exponent}",
                    _ => $"{Coefficient}x^{Exponent}"
        };
    }
}
