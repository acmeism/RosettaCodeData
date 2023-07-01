import java.math.BigInteger;

public class Isqrt {
    private static BigInteger isqrt(BigInteger x) {
        if (x.compareTo(BigInteger.ZERO) < 0) {
            throw new IllegalArgumentException("Argument cannot be negative");
        }
        var q = BigInteger.ONE;
        while (q.compareTo(x) <= 0) {
            q = q.shiftLeft(2);
        }
        var z = x;
        var r = BigInteger.ZERO;
        while (q.compareTo(BigInteger.ONE) > 0) {
            q = q.shiftRight(2);
            var t = z;
            t = t.subtract(r);
            t = t.subtract(q);
            r = r.shiftRight(1);
            if (t.compareTo(BigInteger.ZERO) >= 0) {
                z = t;
                r = r.add(q);
            }
        }
        return r;
    }

    public static void main(String[] args) {
        System.out.println("The integer square root of integers from 0 to 65 are:");
        for (int i = 0; i <= 65; i++) {
            System.out.printf("%s ", isqrt(BigInteger.valueOf(i)));
        }
        System.out.println();

        System.out.println("The integer square roots of powers of 7 from 7^1 up to 7^73 are:");
        System.out.println("power                                    7 ^ power                                                 integer square root");
        System.out.println("----- --------------------------------------------------------------------------------- -----------------------------------------");
        var pow7 = BigInteger.valueOf(7);
        var bi49 = BigInteger.valueOf(49);
        for (int i = 1; i < 74; i += 2) {
            System.out.printf("%2d %,84d %,41d\n", i, pow7, isqrt(pow7));
            pow7 = pow7.multiply(bi49);
        }
    }
}
