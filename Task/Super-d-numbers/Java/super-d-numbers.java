import java.math.BigInteger;

public class SuperDNumbers {

    public static void main(String[] args) {
        for ( int i = 2 ; i <= 9 ; i++ ) {
            superD(i, 10);
        }
    }

    private static final void superD(int d, int max) {
        long start = System.currentTimeMillis();
        String test = "";
        for ( int i = 0 ; i < d ; i++ ) {
            test += (""+d);
        }

        int n = 0;
        int i = 0;
        System.out.printf("First %d super-%d numbers: %n", max, d);
        while ( n < max ) {
            i++;
            BigInteger val = BigInteger.valueOf(d).multiply(BigInteger.valueOf(i).pow(d));
            if ( val.toString().contains(test) ) {
                n++;
                System.out.printf("%d ", i);
            }
        }
        long end = System.currentTimeMillis();
        System.out.printf("%nRun time %d ms%n%n", end-start);

    }

}
