import java.math.BigInteger;

public class MontgomeryReduction {
    private static final BigInteger ZERO = BigInteger.ZERO;
    private static final BigInteger ONE = BigInteger.ONE;
    private static final BigInteger TWO = BigInteger.valueOf(2);

    public static class Montgomery {
        public static final int BASE = 2;

        BigInteger m;
        BigInteger rrm;
        int n;

        public Montgomery(BigInteger m) {
            if (m.compareTo(BigInteger.ZERO) <= 0 || !m.testBit(0)) {
                throw new IllegalArgumentException();
            }
            this.m = m;
            this.n = m.bitLength();
            this.rrm = ONE.shiftLeft(n * 2).mod(m);
        }

        public BigInteger reduce(BigInteger t) {
            BigInteger a = t;
            for (int i = 0; i < n; i++) {
                if (a.testBit(0)) a = a.add(this.m);
                a = a.shiftRight(1);
            }
            if (a.compareTo(m) >= 0) a = a.subtract(this.m);
            return a;
        }
    }

    public static void main(String[] args) {
        BigInteger m  = new BigInteger("750791094644726559640638407699");
        BigInteger x1 = new BigInteger("540019781128412936473322405310");
        BigInteger x2 = new BigInteger("515692107665463680305819378593");

        Montgomery mont = new Montgomery(m);
        BigInteger t1 = x1.multiply(mont.rrm);
        BigInteger t2 = x2.multiply(mont.rrm);

        BigInteger r1 = mont.reduce(t1);
        BigInteger r2 = mont.reduce(t2);
        BigInteger r = ONE.shiftLeft(mont.n);

        System.out.printf("b :  %s\n", Montgomery.BASE);
        System.out.printf("n :  %s\n", mont.n);
        System.out.printf("r :  %s\n", r);
        System.out.printf("m :  %s\n", mont.m);
        System.out.printf("t1:  %s\n", t1);
        System.out.printf("t2:  %s\n", t2);
        System.out.printf("r1:  %s\n", r1);
        System.out.printf("r2:  %s\n", r2);
        System.out.println();
        System.out.printf("Original x1       :  %s\n", x1);
        System.out.printf("Recovered from r1 :  %s\n", mont.reduce(r1));
        System.out.printf("Original x2       :  %s\n", x2);
        System.out.printf("Recovered from r2 :  %s\n", mont.reduce(r2));

        System.out.println();
        System.out.println("Montgomery computation of x1 ^ x2 mod m :");
        BigInteger prod = mont.reduce(mont.rrm);
        BigInteger base = mont.reduce(x1.multiply(mont.rrm));
        BigInteger exp = x2;
        while (exp.bitLength()>0) {
            if (exp.testBit(0)) prod=mont.reduce(prod.multiply(base));
            exp = exp.shiftRight(1);
            base = mont.reduce(base.multiply(base));
        }
        System.out.println(mont.reduce(prod));

        System.out.println();
        System.out.println("Library-based computation of x1 ^ x2 mod m :");
        System.out.println(x1.modPow(x2, m));
    }
}
