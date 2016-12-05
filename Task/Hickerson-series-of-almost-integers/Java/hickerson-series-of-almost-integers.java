import java.math.*;

public class Hickerson {

    final static String LN2 = "0.693147180559945309417232121458";

    public static void main(String[] args) {
        for (int n = 1; n <= 17; n++)
            System.out.printf("%2s is almost integer: %s%n", n, almostInteger(n));
    }

    static boolean almostInteger(int n) {
        BigDecimal a = new BigDecimal(LN2);
        a = a.pow(n + 1).multiply(BigDecimal.valueOf(2));

        long f = n;
        while (--n > 1)
            f *= n;

        BigDecimal b = new BigDecimal(f);
        b = b.divide(a, MathContext.DECIMAL128);

        BigInteger c = b.movePointRight(1).toBigInteger().mod(BigInteger.TEN);

        return c.toString().matches("0|9");
    }
}
