import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.Scanner;

public final class ShapeMachine {

    public static void main(String[] args) {
        Scanner reader = new Scanner(System.in);
        System.out.print("Enter a number: ");
        final BigDecimal userChoice = reader.nextBigDecimal();
        System.out.print("Enter a number of decimal places: ");
        final int decimalPlaces = reader.nextInt();
        reader.close();

        final BigDecimal epsilon = BigDecimal.TEN.pow(-decimalPlaces - 1, MathContext.DECIMAL128);
        int iterations = 0;
        BigDecimal previous = BigDecimal.ZERO;
        BigDecimal current = userChoice;

        while ( current.subtract(previous).abs().compareTo(epsilon) > 0 ) {
            previous = current;
            current = current.add(THREE).multiply(ZERO86);
            iterations += 1;
        }

        final BigDecimal result = current.setScale(decimalPlaces, RoundingMode.HALF_UP);
        System.out.println(userChoice + " converged to " + result + " after " + iterations + " iterations.");
    }

    private static final BigDecimal THREE = new BigDecimal("3.0");
    private static final BigDecimal ZERO86 = new BigDecimal("0.86");

}
