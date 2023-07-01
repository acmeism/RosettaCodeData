import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class MultiplicativeOrder {
    private static final BigInteger ONE = BigInteger.ONE;
    private static final BigInteger TWO = BigInteger.valueOf(2);
    private static final BigInteger THREE = BigInteger.valueOf(3);
    private static final BigInteger TEN = BigInteger.TEN;

    private static class PExp {
        BigInteger prime;
        long exp;

        PExp(BigInteger prime, long exp) {
            this.prime = prime;
            this.exp = exp;
        }
    }

    private static void moTest(BigInteger a, BigInteger n) {
        if (!n.isProbablePrime(20)) {
            System.out.println("Not computed. Modulus must be prime for this algorithm.");
            return;
        }
        if (a.bitLength() < 100) System.out.printf("ord(%s)", a);
        else System.out.print("ord([big])");
        if (n.bitLength() < 100) System.out.printf(" mod %s ", n);
        else System.out.print(" mod [big] ");
        BigInteger mob = moBachShallit58(a, n, factor(n.subtract(ONE)));
        System.out.println("= " + mob);
    }

    private static BigInteger moBachShallit58(BigInteger a, BigInteger n, List<PExp> pf) {
        BigInteger n1 = n.subtract(ONE);
        BigInteger mo = ONE;
        for (PExp pe : pf) {
            BigInteger y = n1.divide(pe.prime.pow((int) pe.exp));
            long o = 0;
            BigInteger x = a.modPow(y, n.abs());
            while (x.compareTo(ONE) > 0) {
                x = x.modPow(pe.prime, n.abs());
                o++;
            }
            BigInteger o1 = BigInteger.valueOf(o);
            o1 = pe.prime.pow(o1.intValue());
            o1 = o1.divide(mo.gcd(o1));
            mo = mo.multiply(o1);
        }
        return mo;
    }

    private static List<PExp> factor(BigInteger n) {
        List<PExp> pf = new ArrayList<>();
        BigInteger nn = n;
        Long e = 0L;
        while (!nn.testBit(e.intValue())) e++;
        if (e > 0L) {
            nn = nn.shiftRight(e.intValue());
            pf.add(new PExp(TWO, e));
        }
        BigInteger s = sqrt(nn);
        BigInteger d = THREE;
        while (nn.compareTo(ONE) > 0) {
            if (d.compareTo(s) > 0) d = nn;
            e = 0L;
            while (true) {
                BigInteger[] qr = nn.divideAndRemainder(d);
                if (qr[1].bitLength() > 0) break;
                nn = qr[0];
                e++;
            }
            if (e > 0L) {
                pf.add(new PExp(d, e));
                s = sqrt(nn);
            }
            d = d.add(TWO);
        }
        return pf;
    }

    private static BigInteger sqrt(BigInteger n) {
        BigInteger b = n;
        while (true) {
            BigInteger a = b;
            b = n.divide(a).add(a).shiftRight(1);
            if (b.compareTo(a) >= 0) return a;
        }
    }

    public static void main(String[] args) {
        moTest(BigInteger.valueOf(37), BigInteger.valueOf(3343));

        BigInteger b = TEN.pow(100).add(ONE);
        moTest(b, BigInteger.valueOf(7919));

        b = TEN.pow(1000).add(ONE);
        moTest(b, BigInteger.valueOf(15485863));

        b = TEN.pow(10000).subtract(ONE);
        moTest(b, BigInteger.valueOf(22801763489L));

        moTest(BigInteger.valueOf(1511678068), BigInteger.valueOf(7379191741L));
        moTest(BigInteger.valueOf(3047753288L), BigInteger.valueOf(2257683301L));
    }
}
