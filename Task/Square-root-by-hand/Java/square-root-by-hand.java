import java.math.BigInteger;

public class SquareRoot {
    public static final BigInteger ONE_HUNDRED = BigInteger.valueOf(100);
    public static final BigInteger TWENTY = BigInteger.valueOf(20);

    public static void main(String[] args) {
        var i = BigInteger.TWO;
        var j = BigInteger.valueOf((long) Math.floor(Math.sqrt(2.0)));
        var k = j;
        var d = j;
        int n = 500;
        int n0 = n;
        do {
            System.out.print(d);
            i = i.subtract(k.multiply(d)).multiply(ONE_HUNDRED);
            k = TWENTY.multiply(j);
            for (d = BigInteger.ONE; d.compareTo(BigInteger.TEN) <= 0; d = d.add(BigInteger.ONE)) {
                if (k.add(d).multiply(d).compareTo(i) > 0) {
                    d = d.subtract(BigInteger.ONE);
                    break;
                }
            }
            j = j.multiply(BigInteger.TEN).add(d);
            k = k.add(d);
            if (n0 > 0) {
                n--;
            }
        } while (n > 0);
        System.out.println();
    }
}
