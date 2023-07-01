import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class EgyptianFractions {
    private static BigInteger gcd(BigInteger a, BigInteger b) {
        if (b.equals(BigInteger.ZERO)) {
            return a;
        }
        return gcd(b, a.mod(b));
    }

    private static class Frac implements Comparable<Frac> {
        private BigInteger num, denom;

        public Frac(BigInteger n, BigInteger d) {
            if (d.equals(BigInteger.ZERO)) {
                throw new IllegalArgumentException("Parameter d may not be zero.");
            }

            BigInteger nn = n;
            BigInteger dd = d;
            if (nn.equals(BigInteger.ZERO)) {
                dd = BigInteger.ONE;
            } else if (dd.compareTo(BigInteger.ZERO) < 0) {
                nn = nn.negate();
                dd = dd.negate();
            }
            BigInteger g = gcd(nn, dd).abs();
            if (g.compareTo(BigInteger.ZERO) > 0) {
                nn = nn.divide(g);
                dd = dd.divide(g);
            }
            num = nn;
            denom = dd;
        }

        public Frac(int n, int d) {
            this(BigInteger.valueOf(n), BigInteger.valueOf(d));
        }

        public Frac plus(Frac rhs) {
            return new Frac(
                num.multiply(rhs.denom).add(denom.multiply(rhs.num)),
                rhs.denom.multiply(denom)
            );
        }

        public Frac unaryMinus() {
            return new Frac(num.negate(), denom);
        }

        public Frac minus(Frac rhs) {
            return plus(rhs.unaryMinus());
        }

        @Override
        public int compareTo(Frac rhs) {
            BigDecimal diff = this.toBigDecimal().subtract(rhs.toBigDecimal());
            if (diff.compareTo(BigDecimal.ZERO) < 0) {
                return -1;
            }
            if (BigDecimal.ZERO.compareTo(diff) < 0) {
                return 1;
            }
            return 0;
        }

        @Override
        public boolean equals(Object obj) {
            if (null == obj || !(obj instanceof Frac)) {
                return false;
            }
            Frac rhs = (Frac) obj;
            return compareTo(rhs) == 0;
        }

        @Override
        public String toString() {
            if (denom.equals(BigInteger.ONE)) {
                return num.toString();
            }
            return String.format("%s/%s", num, denom);
        }

        public BigDecimal toBigDecimal() {
            BigDecimal bdn = new BigDecimal(num);
            BigDecimal bdd = new BigDecimal(denom);
            return bdn.divide(bdd, MathContext.DECIMAL128);
        }

        public List<Frac> toEgyptian() {
            if (num.equals(BigInteger.ZERO)) {
                return Collections.singletonList(this);
            }
            List<Frac> fracs = new ArrayList<>();
            if (num.abs().compareTo(denom.abs()) >= 0) {
                Frac div = new Frac(num.divide(denom), BigInteger.ONE);
                Frac rem = this.minus(div);
                fracs.add(div);
                toEgyptian(rem.num, rem.denom, fracs);
            } else {
                toEgyptian(num, denom, fracs);
            }
            return fracs;
        }

        public void toEgyptian(BigInteger n, BigInteger d, List<Frac> fracs) {
            if (n.equals(BigInteger.ZERO)) {
                return;
            }
            BigDecimal n2 = new BigDecimal(n);
            BigDecimal d2 = new BigDecimal(d);
            BigDecimal[] divRem = d2.divideAndRemainder(n2, MathContext.UNLIMITED);
            BigInteger div = divRem[0].toBigInteger();
            if (divRem[1].compareTo(BigDecimal.ZERO) > 0) {
                div = div.add(BigInteger.ONE);
            }
            fracs.add(new Frac(BigInteger.ONE, div));
            BigInteger n3 = d.negate().mod(n);
            if (n3.compareTo(BigInteger.ZERO) < 0) {
                n3 = n3.add(n);
            }
            BigInteger d3 = d.multiply(div);
            Frac f = new Frac(n3, d3);
            if (f.num.equals(BigInteger.ONE)) {
                fracs.add(f);
                return;
            }
            toEgyptian(f.num, f.denom, fracs);
        }
    }

    public static void main(String[] args) {
        List<Frac> fracs = List.of(
            new Frac(43, 48),
            new Frac(5, 121),
            new Frac(2014, 59)
        );
        for (Frac frac : fracs) {
            List<Frac> list = frac.toEgyptian();
            Frac first = list.get(0);
            if (first.denom.equals(BigInteger.ONE)) {
                System.out.printf("%s -> [%s] + ", frac, first);
            } else {
                System.out.printf("%s -> %s", frac, first);
            }
            for (int i = 1; i < list.size(); ++i) {
                System.out.printf(" + %s", list.get(i));
            }
            System.out.println();
        }

        for (Integer r : List.of(98, 998)) {
            if (r == 98) {
                System.out.println("\nFor proper fractions with 1 or 2 digits:");
            } else {
                System.out.println("\nFor proper fractions with 1, 2 or 3 digits:");
            }

            int maxSize = 0;
            List<Frac> maxSizeFracs = new ArrayList<>();
            BigInteger maxDen = BigInteger.ZERO;
            List<Frac> maxDenFracs = new ArrayList<>();
            boolean[][] sieve = new boolean[r + 1][];
            for (int i = 0; i < r + 1; ++i) {
                sieve[i] = new boolean[r + 2];
            }
            for (int i = 1; i < r; ++i) {
                for (int j = i + 1; j < r + 1; ++j) {
                    if (sieve[i][j]) continue;
                    Frac f = new Frac(i, j);
                    List<Frac> list = f.toEgyptian();
                    int listSize = list.size();
                    if (listSize > maxSize) {
                        maxSize = listSize;
                        maxSizeFracs.clear();
                        maxSizeFracs.add(f);
                    } else if (listSize == maxSize) {
                        maxSizeFracs.add(f);
                    }
                    BigInteger listDen = list.get(list.size() - 1).denom;
                    if (listDen.compareTo(maxDen) > 0) {
                        maxDen = listDen;
                        maxDenFracs.clear();
                        maxDenFracs.add(f);
                    } else if (listDen.equals(maxDen)) {
                        maxDenFracs.add(f);
                    }
                    if (i < r / 2) {
                        int k = 2;
                        while (true) {
                            if (j * k > r + 1) break;
                            sieve[i * k][j * k] = true;
                            k++;
                        }
                    }
                }
            }
            System.out.printf("  largest number of items = %s\n", maxSize);
            System.out.printf("fraction(s) with this number : %s\n", maxSizeFracs);
            String md = maxDen.toString();
            System.out.printf("  largest denominator = %s digits, ", md.length());
            System.out.printf("%s...%s\n", md.substring(0, 20), md.substring(md.length() - 20, md.length()));
            System.out.printf("fraction(s) with this denominator : %s\n", maxDenFracs);
        }
    }
}
