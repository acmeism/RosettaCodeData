public class MöbiusFunction {

    public static void main(String[] args) {
        System.out.printf("First 199 terms of the möbius function are as follows:%n    ");
        for ( int n = 1 ; n < 200 ; n++ ) {
            System.out.printf("%2d  ", möbiusFunction(n));
            if ( (n+1) % 20 == 0 ) {
                System.out.printf("%n");
            }
        }
    }

    private static int MU_MAX = 1_000_000;
    private static int[] MU = null;

    //  Compute mobius function via sieve
    private static int möbiusFunction(int n) {
        if ( MU != null ) {
            return MU[n];
        }

        //  Populate array
        MU = new int[MU_MAX+1];
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
        }
        return MU[n];
    }

}
