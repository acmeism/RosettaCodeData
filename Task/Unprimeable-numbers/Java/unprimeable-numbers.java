public class UnprimeableNumbers {

    private static int MAX = 10_000_000;
    private static boolean[] primes = new boolean[MAX];

    public static void main(String[] args) {
        sieve();
        System.out.println("First 35 unprimeable numbers:");
        displayUnprimeableNumbers(35);
        int n = 600;
        System.out.printf("%nThe %dth unprimeable number = %,d%n%n", n, nthUnprimeableNumber(n));
        int[] lowest = genLowest();
        System.out.println("Least unprimeable number that ends in:");
        for ( int i = 0 ; i <= 9 ; i++ ) {
            System.out.printf(" %d is %,d%n", i, lowest[i]);
        }
    }

    private static int[] genLowest() {
        int[] lowest = new int[10];
        int count = 0;
        int test = 1;
        while ( count < 10 ) {
            test++;
            if ( unPrimable(test) && lowest[test % 10] == 0 ) {
                lowest[test % 10] = test;
                count++;
            }
        }
        return lowest;
    }

    private static int nthUnprimeableNumber(int maxCount) {
        int test = 1;
        int count = 0;
        int result = 0;
        while ( count < maxCount ) {
            test++;
            if ( unPrimable(test) ) {
                count++;
                result = test;
            }
        }
        return result;
    }

    private static void displayUnprimeableNumbers(int maxCount) {
        int test = 1;
        int count = 0;
        while ( count < maxCount ) {
            test++;
            if ( unPrimable(test) ) {
                count++;
                System.out.printf("%d ", test);
            }
        }
        System.out.println();
    }

    private static boolean unPrimable(int test) {
        if ( primes[test] ) {
            return false;
        }
        String s = test + "";
        for ( int i = 0 ; i < s.length() ; i++ ) {
            for ( int j = 0 ; j <= 9 ; j++ ) {
                if ( primes[Integer.parseInt(replace(s, i, j))] ) {
                    return false;
                }
            }
        }
        return true;
    }

    private static String replace(String str, int position, int value) {
        char[] sChar = str.toCharArray();
        sChar[position] = (char) value;
        return str.substring(0, position) + value + str.substring(position + 1);
    }

    private static final void sieve() {
        //  primes
        for ( int i = 2 ; i < MAX ; i++ ) {
            primes[i] = true;
        }
        for ( int i = 2 ; i < MAX ; i++ ) {
            if ( primes[i] ) {
                for ( int j = 2*i ; j < MAX ; j += i ) {
                    primes[j] = false;
                }
            }
        }
    }

}
