import java.math.BigInteger;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

public class PellsEquation {

    public static void main(String[] args) {
        NumberFormat format = NumberFormat.getInstance();
        for ( int n : new int[] {61, 109, 181, 277, 8941} ) {
            BigInteger[] pell = pellsEquation(n);
            System.out.printf("x^2 - %3d * y^2 = 1 for:%n    x = %s%n    y = %s%n%n", n,  format.format(pell[0]),  format.format(pell[1]));
        }
    }

    private static final BigInteger[] pellsEquation(int n) {
        int a0 = (int) Math.sqrt(n);
        if ( a0*a0 == n ) {
            throw new IllegalArgumentException("ERROR 102:  Invalid n = " + n);
        }
        List<Integer> continuedFrac = continuedFraction(n);
        int count = 0;
        BigInteger ajm2 = BigInteger.ONE;
        BigInteger ajm1 = new BigInteger(a0 + "");
        BigInteger bjm2 = BigInteger.ZERO;
        BigInteger bjm1 = BigInteger.ONE;
        boolean stop = (continuedFrac.size() % 2 == 1);
        if ( continuedFrac.size() == 2 ) {
            stop = true;
        }
        while ( true ) {
            count++;
            BigInteger bn = new BigInteger(continuedFrac.get(count) + "");
            BigInteger aj = bn.multiply(ajm1).add(ajm2);
            BigInteger bj = bn.multiply(bjm1).add(bjm2);
            if ( stop && (count == continuedFrac.size()-2 || continuedFrac.size() == 2) ) {
                return new BigInteger[] {aj, bj};
            }
            else if (continuedFrac.size() % 2 == 0 && count == continuedFrac.size()-2 ) {
                stop = true;
            }
            if ( count == continuedFrac.size()-1 ) {
                count = 0;
            }
            ajm2 = ajm1;
            ajm1 = aj;
            bjm2 = bjm1;
            bjm1 = bj;
        }
    }

    private static final List<Integer> continuedFraction(int n) {
        List<Integer> answer = new ArrayList<Integer>();
        int a0 = (int) Math.sqrt(n);
        answer.add(a0);
        int a = -a0;
        int aStart = a;
        int b = 1;
        int bStart = b;

        while ( true ) {
            //count++;
            int[] values = iterateFrac(n, a, b);
            answer.add(values[0]);
            a = values[1];
            b = values[2];
            if (a == aStart && b == bStart) break;
        }
        return answer;
    }

    //  array[0] = new part of cont frac
    //  array[1] = new a
    //  array[2] = new b
    private static final int[] iterateFrac(int n, int a, int b) {
        int x = (int) Math.floor((b * Math.sqrt(n) - b * a)/(n - a * a));
        int[] answer = new int[3];
        answer[0] = x;
        answer[1] = -(b * a + x *(n - a * a)) / b;
        answer[2] = (n - a * a) / b;
        return answer;
    }


}
