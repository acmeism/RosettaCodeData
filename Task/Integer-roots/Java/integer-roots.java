import java.math.BigInteger;

public class IntegerRoots {
    private static BigInteger iRoot(BigInteger base, int n) {
        if (base.compareTo(BigInteger.ZERO) < 0 || n <= 0) {
            throw new IllegalArgumentException();
        }

        int n1 = n - 1;
        BigInteger n2 = BigInteger.valueOf(n);
        BigInteger n3 = BigInteger.valueOf(n1);
        BigInteger c = BigInteger.ONE;
        BigInteger d = n3.add(base).divide(n2);
        BigInteger e = n3.multiply(d).add(base.divide(d.pow(n1))).divide(n2);
        while (!c.equals(d) && !c.equals(e)) {
            c = d;
            d = e;
            e = n3.multiply(e).add(base.divide(e.pow(n1))).divide(n2);
        }
        if (d.compareTo(e) < 0) {
            return d;
        }
        return e;
    }

    public static void main(String[] args) {
        BigInteger b = BigInteger.valueOf(8);
        System.out.print("3rd integer root of 8 = ");
        System.out.println(iRoot(b, 3));

        b = BigInteger.valueOf(9);
        System.out.print("3rd integer root of 9 = ");
        System.out.println(iRoot(b, 3));

        b = BigInteger.valueOf(100).pow(2000).multiply(BigInteger.valueOf(2));
        System.out.print("First 2001 digits of the square root of 2: ");
        System.out.println(iRoot(b, 2));
    }
}
