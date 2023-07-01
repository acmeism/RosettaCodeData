import org.apache.commons.math3.fraction.BigFraction;

public class BernoulliNumbers {

    public static void main(String[] args) {
        for (int n = 0; n <= 60; n++) {
            BigFraction b = bernouilli(n);
            if (!b.equals(BigFraction.ZERO))
                System.out.printf("B(%-2d) = %-1s%n", n , b);
        }
    }

    static BigFraction bernouilli(int n) {
        BigFraction[] A = new BigFraction[n + 1];
        for (int m = 0; m <= n; m++) {
            A[m] = new BigFraction(1, (m + 1));
            for (int j = m; j >= 1; j--)
                A[j - 1] = (A[j - 1].subtract(A[j])).multiply(new BigFraction(j));
        }
        return A[0];
    }
}
