import java.math.BigDecimal;
import java.math.MathContext;
import java.util.Arrays;
import java.util.List;

public class RamanujanConstant {

    public static void main(String[] args) {
        System.out.printf("Ramanujan's Constant to 100 digits = %s%n%n", ramanujanConstant(163, 100));
        System.out.printf("Heegner numbers yielding 'almost' integers:%n");
        List<Integer> heegnerNumbers = Arrays.asList(19, 43, 67, 163);
        List<Integer> heegnerVals = Arrays.asList(96, 960, 5280, 640320);
        for ( int i = 0 ; i < heegnerNumbers.size() ; i++ ) {
            int heegnerNumber = heegnerNumbers.get(i);
            int heegnerVal = heegnerVals.get(i);
            BigDecimal integer = BigDecimal.valueOf(heegnerVal).pow(3).add(BigDecimal.valueOf(744));
            BigDecimal compute = ramanujanConstant(heegnerNumber, 50);
            System.out.printf("%3d : %50s ~ %18s (diff ~ %s)%n", heegnerNumber, compute, integer, integer.subtract(compute, new MathContext(30)).toPlainString());
        }
    }

    public static BigDecimal ramanujanConstant(int sqrt, int digits) {
        //  For accuracy on lat digit, computations with a few extra digits
        MathContext mc = new MathContext(digits + 5);
        return bigE(bigPi(mc).multiply(bigSquareRoot(BigDecimal.valueOf(sqrt), mc), mc), mc).round(new MathContext(digits));
    }

    //  e = 1 + x/1! + x^2/2! + x^3/3! + ...
    public static BigDecimal bigE(BigDecimal exponent, MathContext mc) {
        BigDecimal e = BigDecimal.ONE;
        BigDecimal ak = e;
        int k = 0;
        BigDecimal min = BigDecimal.ONE.divide(BigDecimal.TEN.pow(mc.getPrecision()));
        while ( true ) {
            k++;
            ak = ak.multiply(exponent).divide(BigDecimal.valueOf(k), mc);
            e = e.add(ak, mc);
            if ( ak.compareTo(min) < 0 ) {
                break;
            }
        }
        return e;

    }

    //  See : https://www.craig-wood.com/nick/articles/pi-chudnovsky/
    public static BigDecimal bigPi(MathContext mc) {
        int k = 0;
        BigDecimal ak = BigDecimal.ONE;
        BigDecimal a = ak;
        BigDecimal b = BigDecimal.ZERO;
        BigDecimal c = BigDecimal.valueOf(640320);
        BigDecimal c3 = c.pow(3);
        double digitePerTerm = Math.log10(c.pow(3).divide(BigDecimal.valueOf(24), mc).doubleValue()) - Math.log10(72);
        double digits = 0;
        while ( digits < mc.getPrecision() ) {
            k++;
            digits += digitePerTerm;
            BigDecimal top = BigDecimal.valueOf(-24).multiply(BigDecimal.valueOf(6*k-5)).multiply(BigDecimal.valueOf(2*k-1)).multiply(BigDecimal.valueOf(6*k-1));
            BigDecimal term = top.divide(BigDecimal.valueOf(k*k*k).multiply(c3), mc);
            ak = ak.multiply(term, mc);
            a = a.add(ak, mc);
            b = b.add(BigDecimal.valueOf(k).multiply(ak, mc), mc);
        }
        BigDecimal total = BigDecimal.valueOf(13591409).multiply(a, mc).add(BigDecimal.valueOf(545140134).multiply(b, mc), mc);
        return BigDecimal.valueOf(426880).multiply(bigSquareRoot(BigDecimal.valueOf(10005), mc), mc).divide(total, mc);
    }

    //  See : https://en.wikipedia.org/wiki/Newton's_method#Square_root_of_a_number
    public static BigDecimal bigSquareRoot(BigDecimal squareDecimal, MathContext mc) {
        //  Estimate
        double sqrt = Math.sqrt(squareDecimal.doubleValue());
        BigDecimal x0 = new BigDecimal(sqrt, mc);
        BigDecimal two = BigDecimal.valueOf(2);
        while ( true ) {
            BigDecimal x1 = x0.subtract(x0.multiply(x0, mc).subtract(squareDecimal).divide(two.multiply(x0, mc), mc), mc);
            String x1String = x1.toPlainString();
            String x0String = x0.toPlainString();
            if ( x1String.substring(0, x1String.length()-1).compareTo(x0String.substring(0, x0String.length()-1)) == 0 ) {
                break;
            }
            x0 = x1;
        }
        return x0;
    }

}
