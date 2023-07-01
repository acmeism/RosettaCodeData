public class JacobiSymbol {

    public static void main(String[] args) {
        int max = 30;
        System.out.printf("n\\k ");
        for ( int k = 1 ; k <= max ; k++ ) {
            System.out.printf("%2d  ", k);
        }
        System.out.printf("%n");
        for ( int n = 1 ; n <= max ; n += 2 ) {
            System.out.printf("%2d  ", n);
            for ( int k = 1 ; k <= max ; k++ ) {
                System.out.printf("%2d  ", jacobiSymbol(k, n));
            }
            System.out.printf("%n");
        }
    }


    //  Compute (k n), where k is numerator
    private static int jacobiSymbol(int k, int n) {
        if ( k < 0 || n % 2 == 0 ) {
            throw new IllegalArgumentException("Invalid value. k = " + k + ", n = " + n);
        }
        k %= n;
        int jacobi = 1;
        while ( k > 0 ) {
            while ( k % 2 == 0 ) {
                k /= 2;
                int r = n % 8;
                if ( r == 3 || r == 5 ) {
                    jacobi = -jacobi;
                }
            }
            int temp = n;
            n = k;
            k = temp;
            if ( k % 4 == 3 && n % 4 == 3 ) {
                jacobi = -jacobi;
            }
            k %= n;
        }
        if ( n == 1 ) {
            return jacobi;
        }
        return 0;
    }

}
