import java.util.Arrays;

public class MianChowlaSequence {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        System.out.println("First 30 terms of the Mian–Chowla sequence.");
        mianChowla(1, 30);
        System.out.println("Terms 91 through 100 of the Mian–Chowla sequence.");
        mianChowla(91, 100);
        long end = System.currentTimeMillis();
        System.out.printf("Elapsed = %d ms%n", (end-start));
    }

    private static void mianChowla(int minIndex, int maxIndex) {
        int [] sums = new int[1];
        int [] chowla = new int[maxIndex+1];
        sums[0] = 2;
        chowla[0] = 0;
        chowla[1] = 1;
        if ( minIndex == 1 ) {
            System.out.printf("%d ", 1);
        }
        int chowlaLength = 1;
        for ( int n = 2 ; n <= maxIndex ; n++ ) {

            //  Sequence is strictly increasing.
            int test = chowla[n - 1];
            //  Bookkeeping.  Generate only new sums.
            int[] sumsNew = Arrays.copyOf(sums, sums.length + n);
            int sumNewLength = sums.length;
            int savedsSumNewLength = sumNewLength;

            //  Generate test candidates for the next value of the sequence.
            boolean found = false;
            while ( ! found ) {
                test++;
                found = true;
                sumNewLength = savedsSumNewLength;
                //  Generate test sums
                for ( int j = 0 ; j <= chowlaLength ; j++ ) {
                    int testSum = (j == 0 ? test : chowla[j]) + test;
                    boolean duplicate = false;

                    //  Check if test Sum in array
                    for ( int k = 0 ; k < sumNewLength ; k++ ) {
                        if ( sumsNew[k] == testSum ) {
                            duplicate = true;
                            break;
                        }
                    }
                    if ( ! duplicate ) {
                        //  Add to array
                        sumsNew[sumNewLength] = testSum;
                        sumNewLength++;
                    }
                    else {
                        //  Duplicate found.  Therefore, test candidate of the next value of the sequence is not OK.
                        found = false;
                        break;
                    }
                }
            }

            //  Bingo!  Now update bookkeeping.
            chowla[n] = test;
            chowlaLength++;
            sums = sumsNew;
            if ( n >= minIndex ) {
                System.out.printf("%d %s", chowla[n], (n==maxIndex ? "\n" : ""));
            }
        }
    }

}
