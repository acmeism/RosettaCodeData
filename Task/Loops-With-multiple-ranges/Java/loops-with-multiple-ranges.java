import java.util.ArrayList;
import java.util.List;

public class LoopsWithMultipleRanges {

    private static long sum = 0;
    private static long prod = 1;

    public static void main(String[] args) {
        long x = 5;
        long y = -5;
        long z = -2;
        long one = 1;
        long three = 3;
        long seven = 7;

        List<Long> jList = new ArrayList<>();
        for ( long j = -three     ; j <= pow(3, 3)        ; j += three )  jList.add(j);
        for ( long j = -seven     ; j <= seven            ; j += x )      jList.add(j);
        for ( long j = 555        ; j <= 550-y            ; j += 1 )      jList.add(j);
        for ( long j = 22         ; j >= -28              ; j += -three ) jList.add(j);
        for ( long j = 1927       ; j <= 1939             ; j += 1 )      jList.add(j);
        for ( long j = x          ; j >= y                ; j += z )      jList.add(j);
        for ( long j = pow(11, x) ; j <= pow(11, x) + one ; j += 1 )      jList.add(j);

        List<Long> prodList = new ArrayList<>();
        for ( long j : jList ) {
            sum += Math.abs(j);
            if ( Math.abs(prod) < pow(2, 27) && j != 0 ) {
                prodList.add(j);
                prod *= j;
            }
        }

        System.out.printf(" sum        = %,d%n", sum);
        System.out.printf("prod        = %,d%n", prod);
        System.out.printf("j values    = %s%n", jList);
        System.out.printf("prod values = %s%n", prodList);
    }

    private static long pow(long base, long exponent) {
        return (long) Math.pow(base, exponent);
    }

}
