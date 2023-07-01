import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.util.ArrayList;
import java.util.List;

public class MetallicRatios {

    private static String[] ratioDescription = new String[] {"Platinum", "Golden", "Silver", "Bronze", "Copper", "Nickel", "Aluminum", "Iron", "Tin", "Lead"};

    public static void main(String[] args) {
        int elements = 15;
        for ( int b = 0 ; b < 10 ; b++ ) {
            System.out.printf("Lucas sequence for %s ratio, where b = %d:%n", ratioDescription[b], b);
            System.out.printf("First %d elements: %s%n", elements, lucasSequence(1, 1, b, elements));
            int decimalPlaces = 32;
            BigDecimal[] ratio = lucasSequenceRatio(1, 1, b, decimalPlaces+1);
            System.out.printf("Value to %d decimal places after %s iterations : %s%n", decimalPlaces, ratio[1], ratio[0]);
            System.out.printf("%n");
        }
        int b = 1;
        int decimalPlaces = 256;
        System.out.printf("%s ratio, where b = %d:%n", ratioDescription[b], b);
        BigDecimal[] ratio = lucasSequenceRatio(1, 1, b, decimalPlaces+1);
        System.out.printf("Value to %d decimal places after %s iterations : %s%n", decimalPlaces, ratio[1], ratio[0]);
    }

    private static BigDecimal[] lucasSequenceRatio(int x0, int x1, int b, int digits) {
        BigDecimal x0Bi = BigDecimal.valueOf(x0);
        BigDecimal x1Bi = BigDecimal.valueOf(x1);
        BigDecimal bBi = BigDecimal.valueOf(b);
        MathContext mc = new MathContext(digits);
        BigDecimal fractionPrior = x1Bi.divide(x0Bi, mc);
        int iterations = 0;
        while ( true ) {
            iterations++;
            BigDecimal x = bBi.multiply(x1Bi).add(x0Bi);
            BigDecimal fractionCurrent = x.divide(x1Bi, mc);
            if ( fractionCurrent.compareTo(fractionPrior) == 0 ) {
                break;
            }
            x0Bi = x1Bi;
            x1Bi = x;
            fractionPrior = fractionCurrent;
        }
        return new BigDecimal[] {fractionPrior, BigDecimal.valueOf(iterations)};
    }

    private static List<BigInteger> lucasSequence(int x0, int x1, int b, int n) {
        List<BigInteger> list = new ArrayList<>();
        BigInteger x0Bi = BigInteger.valueOf(x0);
        BigInteger x1Bi = BigInteger.valueOf(x1);
        BigInteger bBi = BigInteger.valueOf(b);
        if ( n > 0 ) {
            list.add(x0Bi);
        }
        if ( n > 1 ) {
            list.add(x1Bi);
        }
        while ( n > 2 ) {
            BigInteger x = bBi.multiply(x1Bi).add(x0Bi);
            list.add(x);
            n--;
            x0Bi = x1Bi;
            x1Bi = x;
        }
        return list;
    }

}
