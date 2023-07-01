public class MertensFunction {

    public static void main(String[] args) {
        System.out.printf("First 199 terms of the merten function are as follows:%n    ");
        for ( int n = 1 ; n < 200 ; n++ ) {
            System.out.printf("%2d  ", mertenFunction(n));
            if ( (n+1) % 20 == 0 ) {
                System.out.printf("%n");
            }
        }

        for ( int exponent = 3 ; exponent<= 8 ; exponent++ ) {
            int zeroCount = 0;
            int zeroCrossingCount = 0;
            int positiveCount = 0;
            int negativeCount = 0;
            int mSum = 0;
            int mMin = Integer.MAX_VALUE;
            int mMinIndex = 0;
            int mMax = Integer.MIN_VALUE;
            int mMaxIndex = 0;
            int nMax = (int) Math.pow(10, exponent);
            for ( int n = 1 ; n <= nMax ; n++ ) {
                int m = mertenFunction(n);
                mSum += m;
                if ( m < mMin ) {
                    mMin = m;
                    mMinIndex = n;
                }
                if ( m > mMax ) {
                    mMax = m;
                    mMaxIndex = n;
                }
                if ( m > 0 ) {
                    positiveCount++;
                }
                if ( m < 0 ) {
                    negativeCount++;
                }
                if ( m == 0 ) {
                    zeroCount++;
                }
                if ( m == 0 && mertenFunction(n - 1) != 0 ) {
                    zeroCrossingCount++;
                }
            }
            System.out.printf("%nFor M(x) with x from 1 to %,d%n", nMax);
            System.out.printf("The maximum of M(x) is M(%,d) = %,d.%n", mMaxIndex, mMax);
            System.out.printf("The minimum of M(x) is M(%,d) = %,d.%n", mMinIndex, mMin);
            System.out.printf("The sum of M(x) is %,d.%n", mSum);
            System.out.printf("The count of positive M(x) is %,d, count of negative M(x) is %,d.%n", positiveCount, negativeCount);
            System.out.printf("M(x) has %,d zeroes in the interval.%n", zeroCount);
            System.out.printf("M(x) has %,d crossings in the interval.%n", zeroCrossingCount);
        }
    }

    private static int MU_MAX = 100_000_000;
    private static int[] MU = null;
    private static int[] MERTEN = null;

    //  Compute mobius and merten function via sieve
    private static int mertenFunction(int n) {
        if ( MERTEN != null ) {
            return MERTEN[n];
        }

        //  Populate array
        MU = new int[MU_MAX+1];
        MERTEN = new int[MU_MAX+1];
        MERTEN[1] = 1;
        int sqrt = (int) Math.sqrt(MU_MAX);
        for ( int i = 0 ; i < MU_MAX ; i++ ) {
            MU[i] = 1;
        }

        for ( int i = 2 ; i <= sqrt ; i++ ) {
            if ( MU[i] == 1 ) {
                //  for each factor found, swap + and -
                for ( int j = i ; j <= MU_MAX ; j += i ) {
                    MU[j] *= -i;
                }
                //  square factor = 0
                for ( int j = i*i ; j <= MU_MAX ; j += i*i ) {
                    MU[j] = 0;
                }
            }
        }

        int sum = 1;
        for ( int i = 2 ; i <= MU_MAX ; i++ ) {
            if ( MU[i] == i ) {
                MU[i] = 1;
            }
            else if ( MU[i] == -i ) {
                MU[i] = -1;
            }
            else if ( MU[i] < 0 ) {
                MU[i] = 1;
            }
            else if ( MU[i] > 0 ) {
                MU[i] = -1;
            }
            sum += MU[i];
            MERTEN[i] = sum;
        }
        return MERTEN[n];
    }

}
