import java.math.BigInteger;

public class PrimeSum {
    private static int digitSum(BigInteger bi) {
        int sum = 0;
        while (bi.compareTo(BigInteger.ZERO) > 0) {
            BigInteger[] dr = bi.divideAndRemainder(BigInteger.TEN);
            sum += dr[1].intValue();
            bi = dr[0];
        }
        return sum;
    }

    public static void main(String[] args) {
        BigInteger fiveK = BigInteger.valueOf(5_000);
        BigInteger bi = BigInteger.valueOf(2);
        while (bi.compareTo(fiveK) < 0) {
            if (digitSum(bi) == 25) {
                System.out.print(bi);
                System.out.print("  ");
            }
            bi = bi.nextProbablePrime();
        }
        System.out.println();
    }
}
