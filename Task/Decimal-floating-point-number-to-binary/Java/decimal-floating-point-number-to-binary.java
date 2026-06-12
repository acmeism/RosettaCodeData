import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;

public class DecimalToBinary {

    public static void main(String[] args) {
        for ( String s : new String[] {"23.34375", ".1", "3.1415926535897932"} ) {
            String binary = decimalToBinary(new BigDecimal(s));
            System.out.printf("%s => %s%n", s, binary);
            System.out.printf("%s => %s%n", binary, binaryToDecimal(binary));
        }
    }

    private static BigDecimal binaryToDecimal(String binary) {
        return binaryToDecimal(binary, 50);
    }

    private static BigDecimal binaryToDecimal(String binary, int digits) {
        int decimalPosition = binary.indexOf(".");
        String integer = decimalPosition >= 0 ? binary.substring(0, decimalPosition) : binary;
        String fractional = decimalPosition >= 0 ? binary.substring(decimalPosition+1) : "";

        //  Integer part
        BigDecimal result = BigDecimal.ZERO;
        BigDecimal powTwo = BigDecimal.ONE;
        BigDecimal two = BigDecimal.valueOf(2);
        for ( char c : new StringBuilder(integer).reverse().toString().toCharArray() ) {
            result = result.add(powTwo.multiply(BigDecimal.valueOf(c - '0')));
            powTwo = powTwo.multiply(two);
        }

        //  Fractional part
        MathContext mc = new MathContext(digits);
        powTwo = BigDecimal.ONE;
        for ( char c : fractional.toCharArray() ) {
            powTwo = powTwo.divide(two);
            result = result.add(powTwo.multiply(BigDecimal.valueOf(c - '0')), mc);
        }

        return result;
    }

    private static String decimalToBinary(BigDecimal decimal) {
        return decimalToBinary(decimal, 50);
    }

    private static String decimalToBinary(BigDecimal decimal, int digits) {
        BigDecimal integer = decimal.setScale(0, RoundingMode.FLOOR);
        BigDecimal fractional = decimal.subtract(integer);

        StringBuilder sb = new StringBuilder();

        //  Integer part
        BigDecimal two = BigDecimal.valueOf(2);
        BigDecimal zero = BigDecimal.ZERO;
        while ( integer.compareTo(zero) > 0 ) {
            BigDecimal[] result = integer.divideAndRemainder(two);
            sb.append(result[1]);
            integer = result[0];
        }
        sb.reverse();

        //  Fractional part
        int count = 0;
        if ( fractional.compareTo(zero) != 0 ) {
            sb.append(".");
        }
        while ( fractional.compareTo(zero) != 0 ) {
            count++;
            fractional = fractional.multiply(two);
            sb.append(fractional.setScale(0, RoundingMode.FLOOR));
            if ( fractional.compareTo(BigDecimal.ONE) >= 0 ) {
                fractional = fractional.subtract(BigDecimal.ONE);
            }
            if ( count >= digits ) {
                break;
            }
        }

        return sb.toString();
    }

}
