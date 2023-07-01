import java.math.MathContext
import java.util.stream.LongStream

class FaulhabersTriangle {
    private static final MathContext MC = new MathContext(256)

    private static long gcd(long a, long b) {
        if (b == 0) {
            return a
        }
        return gcd(b, a % b)
    }

    private static class Frac implements Comparable<Frac> {
        private long num
        private long denom

        public static final Frac ZERO = new Frac(0, 1)

        Frac(long n, long d) {
            if (d == 0) throw new IllegalArgumentException("d must not be zero")
            long nn = n
            long dd = d
            if (nn == 0) {
                dd = 1
            } else if (dd < 0) {
                nn = -nn
                dd = -dd
            }
            long g = Math.abs(gcd(nn, dd))
            if (g > 1) {
                nn /= g
                dd /= g
            }
            num = nn
            denom = dd
        }

        Frac plus(Frac rhs) {
            return new Frac(num * rhs.denom + denom * rhs.num, rhs.denom * denom)
        }

        Frac negative() {
            return new Frac(-num, denom)
        }

        Frac minus(Frac rhs) {
            return this + -rhs
        }

        Frac multiply(Frac rhs) {
            return new Frac(this.num * rhs.num, this.denom * rhs.denom)
        }

        @Override
        int compareTo(Frac o) {
            double diff = toDouble() - o.toDouble()
            return Double.compare(diff, 0.0)
        }

        @Override
        boolean equals(Object obj) {
            return null != obj && obj instanceof Frac && this == (Frac) obj
        }

        @Override
        String toString() {
            if (denom == 1) {
                return Long.toString(num)
            }
            return String.format("%d/%d", num, denom)
        }

        double toDouble() {
            return (double) num / denom
        }

        BigDecimal toBigDecimal() {
            return BigDecimal.valueOf(num).divide(BigDecimal.valueOf(denom), MC)
        }
    }

    private static Frac bernoulli(int n) {
        if (n < 0) throw new IllegalArgumentException("n may not be negative or zero")
        Frac[] a = new Frac[n + 1]
        Arrays.fill(a, Frac.ZERO)
        for (int m = 0; m <= n; ++m) {
            a[m] = new Frac(1, m + 1)
            for (int j = m; j >= 1; --j) {
                a[j - 1] = (a[j - 1] - a[j]) * new Frac(j, 1)
            }
        }
        // returns 'first' Bernoulli number
        if (n != 1) return a[0]
        return -a[0]
    }

    private static long binomial(int n, int k) {
        if (n < 0 || k < 0 || n < k) throw new IllegalArgumentException()
        if (n == 0 || k == 0) return 1
        long num = LongStream.rangeClosed(k + 1, n).reduce(1, { a, b -> a * b })
        long den = LongStream.rangeClosed(2, n - k).reduce(1, { acc, i -> acc * i })
        return num / den
    }

    private static Frac[] faulhaberTriangle(int p) {
        Frac[] coeffs = new Frac[p + 1]
        Arrays.fill(coeffs, Frac.ZERO)
        Frac q = new Frac(1, p + 1)
        int sign = -1
        for (int j = 0; j <= p; ++j) {
            sign *= -1
            coeffs[p - j] = q * new Frac(sign, 1) * new Frac(binomial(p + 1, j), 1) * bernoulli(j)
        }
        return coeffs
    }

    static void main(String[] args) {
        for (int i = 0; i <= 9; ++i) {
            Frac[] coeffs = faulhaberTriangle(i)
            for (Frac coeff : coeffs) {
                printf("%5s  ", coeff)
            }
            println()
        }
        println()
        // get coeffs for (k + 1)th row
        int k = 17
        Frac[] cc = faulhaberTriangle(k)
        int n = 1000
        BigDecimal nn = BigDecimal.valueOf(n)
        BigDecimal np = BigDecimal.ONE
        BigDecimal sum = BigDecimal.ZERO
        for (Frac c : cc) {
            np = np * nn
            sum = sum.add(np * c.toBigDecimal())
        }
        println(sum.toBigInteger())
    }
}
