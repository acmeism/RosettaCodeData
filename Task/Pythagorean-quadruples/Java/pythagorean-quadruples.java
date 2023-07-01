import java.util.ArrayList;
import java.util.List;

public class PythagoreanQuadruples {

    public static void main(String[] args) {
        long d = 2200;
        System.out.printf("Values of d < %d where a, b, and c are non-zero and a^2 + b^2 + c^2 = d^2 has no solutions:%n%s%n", d, getPythagoreanQuadruples(d));
    }

    //  See:  https://oeis.org/A094958
    private static List<Long> getPythagoreanQuadruples(long max) {
        List<Long> list = new ArrayList<>();
        long n = -1;
        long m = -1;
        while ( true ) {
            long nTest = (long) Math.pow(2, n+1);
            long mTest = (long) (5L * Math.pow(2, m+1));
            long test = 0;
            if ( nTest > mTest ) {
                test = mTest;
                m++;
            }
            else {
                test = nTest;
                n++;
            }
            if ( test < max ) {
                list.add(test);
            }
            else {
                break;
            }
        }
        return list;
    }

}
