public class FuscSequence {

    public static void main(String[] args) {
        System.out.println("Show the first 61 fusc numbers (starting at zero) in a horizontal format");
        for ( int n = 0 ; n < 61 ; n++ ) {
            System.out.printf("%,d ", fusc[n]);
        }

        System.out.printf("%n%nShow the fusc number (and its index) whose length is greater than any previous fusc number length.%n");
        int start = 0;
        for (int i = 0 ; i <= 5 ; i++ ) {
            int val = i != 0 ? (int) Math.pow(10, i) : -1;
            for ( int j = start ; j < FUSC_MAX ; j++ ) {
                if ( fusc[j] > val ) {
                    System.out.printf("fusc[%,d] = %,d%n", j, fusc[j] );
                    start = j;
                    break;
                }
            }
        }
    }

    private static final int FUSC_MAX = 30000000;
    private static int[] fusc = new int[FUSC_MAX];

    static {
        fusc[0] = 0;
        fusc[1] = 1;
        for ( int n = 2 ; n < FUSC_MAX ; n++ ) {
            fusc[n] = (n % 2 == 0 ? fusc[n/2] : fusc[(n-1)/2] + fusc[(n+1)/2]);
        }
    }
}
