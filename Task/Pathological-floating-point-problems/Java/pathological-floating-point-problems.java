import java.math.BigDecimal;
import java.math.RoundingMode;

public class FPProblems {
    public static void wrongConvergence() {
        int[] INDEXES = new int[] { 3, 4, 5, 6, 7, 8, 20, 30, 50, 100 };

        // Standard 64-bit floating point
        double[] fpValues = new double[100];
        fpValues[0] = 2.0;
        fpValues[1] = -4.0;
        for (int i = 2; i < fpValues.length; i++) {
            fpValues[i] = 111.0 - 1130.0 / fpValues[i - 1] + 3000.0 / (fpValues[i - 1] * fpValues[i - 2]);
        }

        // Using rational representation
        BigRational[] brValues = new BigRational[100];
        brValues[0] = BigRational.valueOf(2);
        brValues[1] = BigRational.valueOf(-4);
        for (int i = 2; i < brValues.length; i++) {
            // Using intermediate values for better readability
            BigRational clause2 = BigRational.valueOf(1130).divide(brValues[i - 1]);
            BigRational clause3 = BigRational.valueOf(3000).divide(brValues[i - 1].multiply(brValues[i - 2]));
            brValues[i] = BigRational.valueOf(111).subtract(clause2).add(clause3);
        }

        System.out.println("Wrong Convergence Sequence");
        for (int n : INDEXES) {
            BigDecimal value = brValues[n - 1].toBigDecimal(16, RoundingMode.HALF_UP);
            System.out.println("  For index " + n + ", FP value is " + fpValues[n - 1] + ", and rounded BigRational value is " + value.toPlainString());
        }

        return;
    }

    public static void chaoticBankSociety() {
        System.out.println("Chaotic Bank Society");
        double balance = Math.E - 1.0;

        // Calculate e using first 1000 terms of the reciprocal of factorials formula
        BigRational e = BigRational.ONE;
        BigRational d = BigRational.ONE;
        for (int i = 1; i < 1000; i++) {
            d = d.multiply(BigRational.valueOf(i));
            e = e.add(d.reciprocal());
        }
        System.out.println("DEBUG: e=" + e.toBigDecimal(100, RoundingMode.HALF_UP).toPlainString());

        // Alternatively,
        // BigRational e = BigRational.valueOf(Math.E);

        BigRational brBalance = e.subtract(BigRational.ONE);
        for (int year = 1; year <= 25; year++) {
            balance = (balance * year) - 1.0;
            brBalance = brBalance.multiply(BigRational.valueOf(year)).subtract(BigRational.ONE);
            BigDecimal bdValue = brBalance.toBigDecimal(16, RoundingMode.HALF_UP);
            System.out.println("  Year=" + year + ", FP balance=" + balance + ", BigRational balance=" + bdValue.toPlainString());
        }
    }

    public static void siegfriedRump() {
        System.out.println("Siegfried Rump formula");
        double fpValue;
        {
            double a = 77617.0;
            double b = 33096.0;
            fpValue = 333.75 * Math.pow(b, 6) + a * a * (11.0 * a * a * b * b - Math.pow(b, 6) - 121.0 * Math.pow(b, 4) - 2.0) + 5.5 * Math.pow(b, 8) + a / (2.0 * b);
        }

        BigRational brValue;
        {
            BigRational a = BigRational.valueOf(77617);
            BigRational b = BigRational.valueOf(33096);
            BigRational clause1 = BigRational.valueOf(333.75).multiply(b.pow(6));
            BigRational clause2a = BigRational.valueOf(11).multiply(a).multiply(a).multiply(b).multiply(b);
            BigRational clause2b = b.pow(6).add(BigRational.valueOf(121).multiply(b.pow(4))).add(BigRational.valueOf(2));
            BigRational clause2 = a.multiply(a).multiply(clause2a.subtract(clause2b));
            BigRational clause3 = BigRational.valueOf(5.5).multiply(b.pow(8));
            BigRational clause4 = a.divide(b.multiply(BigRational.valueOf(2)));
            brValue = clause1.add(clause2).add(clause3).add(clause4);
        }

        System.out.println("  FP value is " + fpValue);
        System.out.println("  BigRational rounded value is " + brValue.toBigDecimal(64, RoundingMode.HALF_UP).toPlainString());
        System.out.println("  BigRational full value is " + brValue.toString());
    }

    public static void main(String... args) {
        wrongConvergence();

        System.out.println();
        chaoticBankSociety();

        System.out.println();
        siegfriedRump();
    }
}
