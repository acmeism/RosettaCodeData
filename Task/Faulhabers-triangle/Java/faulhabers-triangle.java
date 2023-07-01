import java.math.BigDecimal;
import java.math.MathContext;
import java.util.Arrays;
import java.util.stream.LongStream;

public class FaulhabersTriangle {
    private static final MathContext MC = new MathContext(256);

    private static long gcd(long a, long b) {
        if (b == 0) {
            return a;
        }
        return gcd(b, a % b);
    }

    private static class Frac implements Comparable<Frac> {
        private long num;
        private long denom;

        public static final Frac ZERO = new Frac(0, 1);

        public Frac(long n, long d) {
            if (d == 0) throw new IllegalArgumentException("d must not be zero");
            long nn = n;
            long dd = d;
            if (nn == 0) {
                dd = 1;
            } else if (dd < 0) {
                nn = -nn;
                dd = -dd;
            }
            long g = Math.abs(gcd(nn, dd));
            if (g > 1) {
                nn /= g;
                dd /= g;
            }
            num = nn;
            denom = dd;
        }

        public Frac plus(Frac rhs) {
            return new Frac(num * rhs.denom + denom * rhs.num, rhs.denom * denom);
        }

        public Frac unaryMinus() {
            return new Frac(-num, denom);
        }

        public Frac minus(Frac rhs) {
            return this.plus(rhs.unaryMinus());
        }

        public Frac times(Frac rhs) {
            return new Frac(this.num * rhs.num, this.denom * rhs.denom);
        }

        @Override
        public int compareTo(Frac o) {
            double diff = toDouble() - o.toDouble();
            return Double.compare(diff, 0.0);
        }

        @Override
        public boolean equals(Object obj) {
            return null != obj && obj instanceof Frac && this.compareTo((Frac) obj) == 0;
        }

        @Override
        public String toString() {
            if (denom == 1) {
                return Long.toString(num);
            }
            return String.format("%d/%d", num, denom);
        }

        public double toDouble() {
            return (double) num / denom;
        }

        public BigDecimal toBigDecimal() {
            return BigDecimal.valueOf(num).divide(BigDecimal.valueOf(denom), MC);
        }
    }

    private static Frac bernoulli(int n) {
        if (n < 0) throw new IllegalArgumentException("n may not be negative or zero");
        Frac[] a = new Frac[n + 1];
        Arrays.fill(a, Frac.ZERO);
        for (int m = 0; m <= n; ++m) {
            a[m] = new Frac(1, m + 1);
            for (int j = m; j >= 1; --j) {
                a[j - 1] = a[j - 1].minus(a[j]).times(new Frac(j, 1));
            }
        }
        // returns 'first' Bernoulli number
        if (n != 1) return a[0];
        return a[0].unaryMinus();
    }

    private static long binomial(int n, int k) {
        if (n < 0 || k < 0 || n < k) throw new IllegalArgumentException();
        if (n == 0 || k == 0) return 1;
        long num = LongStream.rangeClosed(k + 1, n).reduce(1, (a, b) -> a * b);
        long den = LongStream.rangeClosed(2, n - k).reduce(1, (acc, i) -> acc * i);
        return num / den;
    }

    private static Frac[] faulhaberTriangle(int p) {
        Frac[] coeffs = new Frac[p + 1];
        Arrays.fill(coeffs, Frac.ZERO);
        Frac q = new Frac(1, p + 1);
        int sign = -1;
        for (int j = 0; j <= p; ++j) {
            sign *= -1;
            coeffs[p - j] = q.times(new Frac(sign, 1)).times(new Frac(binomial(p + 1, j), 1)).times(bernoulli(j));
        }
        return coeffs;
    }

    public static void main(String[] args) {
        for (int i = 0; i <= 9; ++i) {
            Frac[] coeffs = faulhaberTriangle(i);
            for (Frac coeff : coeffs) {
                System.out.printf("%5s  ", coeff);
            }
            System.out.println();
        }
        System.out.println();
        // get coeffs for (k + 1)th row
        int k = 17;
        Frac[] cc = faulhaberTriangle(k);
        int n = 1000;
        BigDecimal nn = BigDecimal.valueOf(n);
        BigDecimal np = BigDecimal.ONE;
        BigDecimal sum = BigDecimal.ZERO;
        for (Frac c : cc) {
            np = np.multiply(nn);
            sum = sum.add(np.multiply(c.toBigDecimal()));
        }
        System.out.println(sum.toBigInteger());
    }
}
