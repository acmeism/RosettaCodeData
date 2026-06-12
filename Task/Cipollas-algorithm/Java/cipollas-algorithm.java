import java.math.BigInteger;
import java.util.function.BiFunction;
import java.util.function.Function;

public class CipollasAlgorithm {
    private static final BigInteger BIG = BigInteger.TEN.pow(50).add(BigInteger.valueOf(151));
    private static final BigInteger BIG_TWO = BigInteger.valueOf(2);

    private static class Point {
        BigInteger x;
        BigInteger y;

        Point(BigInteger x, BigInteger y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public String toString() {
            return String.format("(%s, %s)", this.x, this.y);
        }
    }

    private static class Triple {
        BigInteger x;
        BigInteger y;
        boolean b;

        Triple(BigInteger x, BigInteger y, boolean b) {
            this.x = x;
            this.y = y;
            this.b = b;
        }

        @Override
        public String toString() {
            return String.format("(%s, %s, %s)", this.x, this.y, this.b);
        }
    }

    private static Triple c(String ns, String ps) {
        BigInteger n = new BigInteger(ns);
        BigInteger p = !ps.isEmpty() ? new BigInteger(ps) : BIG;

        // Legendre symbol, returns 1, 0 or p - 1
        Function<BigInteger, BigInteger> ls = (BigInteger a)
            -> a.modPow(p.subtract(BigInteger.ONE).divide(BIG_TWO), p);

        // Step 0, validate arguments
        if (!ls.apply(n).equals(BigInteger.ONE)) {
            return new Triple(BigInteger.ZERO, BigInteger.ZERO, false);
        }

        // Step 1, find a, omega2
        BigInteger a = BigInteger.ZERO;
        BigInteger omega2;
        while (true) {
            omega2 = a.multiply(a).add(p).subtract(n).mod(p);
            if (ls.apply(omega2).equals(p.subtract(BigInteger.ONE))) {
                break;
            }
            a = a.add(BigInteger.ONE);
        }

        // multiplication in Fp2
        BigInteger finalOmega = omega2;
        BiFunction<Point, Point, Point> mul = (Point aa, Point bb) -> new Point(
            aa.x.multiply(bb.x).add(aa.y.multiply(bb.y).multiply(finalOmega)).mod(p),
            aa.x.multiply(bb.y).add(bb.x.multiply(aa.y)).mod(p)
        );

        // Step 2, compute power
        Point r = new Point(BigInteger.ONE, BigInteger.ZERO);
        Point s = new Point(a, BigInteger.ONE);
        BigInteger nn = p.add(BigInteger.ONE).shiftRight(1).mod(p);
        while (nn.compareTo(BigInteger.ZERO) > 0) {
            if (nn.and(BigInteger.ONE).equals(BigInteger.ONE)) {
                r = mul.apply(r, s);
            }
            s = mul.apply(s, s);
            nn = nn.shiftRight(1);
        }

        // Step 3, check x in Fp
        if (!r.y.equals(BigInteger.ZERO)) {
            return new Triple(BigInteger.ZERO, BigInteger.ZERO, false);
        }

        // Step 5, check x * x = n
        if (!r.x.multiply(r.x).mod(p).equals(n)) {
            return new Triple(BigInteger.ZERO, BigInteger.ZERO, false);
        }

        // Step 4, solutions
        return new Triple(r.x, p.subtract(r.x), true);
    }

    public static void main(String[] args) {
        System.out.println(c("10", "13"));
        System.out.println(c("56", "101"));
        System.out.println(c("8218", "10007"));
        System.out.println(c("8219", "10007"));
        System.out.println(c("331575", "1000003"));
        System.out.println(c("665165880", "1000000007"));
        System.out.println(c("881398088036", "1000000000039"));
        System.out.println(c("34035243914635549601583369544560650254325084643201", ""));
    }
}
