//  Title:  Hofstadter-Conway $10,000 sequence

public class HofstadterConwaySequence {

    private static int MAX = (int) Math.pow(2, 20) + 1;
    private static int[] HCS = new int[MAX];
    static {
        HCS[1] = 1;
        HCS[2] = 1;
        for ( int n = 3 ; n < MAX ; n++ ) {
            int nm1 = HCS[n - 1];
            HCS[n] = HCS[nm1] + HCS[n - nm1];
        }
    }

    public static void main(String[] args) {
        int mNum = 0;
        for ( int m = 1 ; m < 20 ; m++ ) {
            int min = (int) Math.pow(2, m);
            int max = min * 2;
            double maxRatio = 0.0;
            int nVal = 0;
            for ( int n = min ; n <= max ; n ++ ) {
                double ratio = (double) HCS[n] / n;
                if ( ratio > maxRatio ) {
                    maxRatio = Math.max(ratio,  maxRatio);
                    nVal = n;
                }
                if ( ratio >= 0.55 ) {
                    mNum = n;
                }
            }
            System.out.printf("Max ratio between 2^%d and 2^%d is %f at n = %,d%n", m, m+1, maxRatio, nVal);
        }
        System.out.printf("Mallow's number is %d.%n", mNum);
    }

}
