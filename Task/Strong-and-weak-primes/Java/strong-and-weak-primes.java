public class StrongAndWeakPrimes {

    private static int MAX = 10_000_000 + 1000;
    private static boolean[] primes = new boolean[MAX];

    public static void main(String[] args) {
        sieve();
        System.out.println("First 36 strong primes:");
        displayStrongPrimes(36);
        for ( int n : new int[] {1_000_000, 10_000_000}) {
            System.out.printf("Number of strong primes below %,d = %,d%n", n, strongPrimesBelow(n));
        }
        System.out.println("First 37 weak primes:");
        displayWeakPrimes(37);
        for ( int n : new int[] {1_000_000, 10_000_000}) {
            System.out.printf("Number of weak primes below %,d = %,d%n", n, weakPrimesBelow(n));
        }
    }

    private static int weakPrimesBelow(int maxPrime) {
        int priorPrime = 2;
        int currentPrime = 3;
        int count = 0;
        while ( currentPrime < maxPrime ) {
            int nextPrime = getNextPrime(currentPrime);
            if ( currentPrime * 2 < priorPrime + nextPrime ) {
                count++;
            }
            priorPrime = currentPrime;
            currentPrime = nextPrime;
        }
        return count;
    }

    private static void displayWeakPrimes(int maxCount) {
        int priorPrime = 2;
        int currentPrime = 3;
        int count = 0;
        while ( count < maxCount ) {
            int nextPrime = getNextPrime(currentPrime);
            if ( currentPrime * 2 < priorPrime + nextPrime) {
                count++;
                System.out.printf("%d ", currentPrime);
            }
            priorPrime = currentPrime;
            currentPrime = nextPrime;
        }
        System.out.println();
    }

    private static int getNextPrime(int currentPrime) {
        int nextPrime = currentPrime + 2;
        while ( ! primes[nextPrime] ) {
            nextPrime += 2;
        }
        return nextPrime;
    }

    private static int strongPrimesBelow(int maxPrime) {
        int priorPrime = 2;
        int currentPrime = 3;
        int count = 0;
        while ( currentPrime < maxPrime ) {
            int nextPrime = getNextPrime(currentPrime);
            if ( currentPrime * 2 > priorPrime + nextPrime ) {
                count++;
            }
            priorPrime = currentPrime;
            currentPrime = nextPrime;
        }
        return count;
    }

    private static void displayStrongPrimes(int maxCount) {
        int priorPrime = 2;
        int currentPrime = 3;
        int count = 0;
        while ( count < maxCount ) {
            int nextPrime = getNextPrime(currentPrime);
            if ( currentPrime * 2 > priorPrime + nextPrime) {
                count++;
                System.out.printf("%d ", currentPrime);
            }
            priorPrime = currentPrime;
            currentPrime = nextPrime;
        }
        System.out.println();
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
