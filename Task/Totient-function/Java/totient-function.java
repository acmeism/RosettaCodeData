public class TotientFunction {

    public static void main(String[] args) {
        computePhi();
        System.out.println("Compute and display phi for the first 25 integers.");
        System.out.printf("n  Phi  IsPrime%n");
        for ( int n = 1 ; n <= 25 ; n++ ) {
            System.out.printf("%2d  %2d  %b%n", n, phi[n], (phi[n] == n-1));
        }
        for ( int i = 2 ; i < 8 ; i++ ) {
            int max = (int) Math.pow(10, i);
            System.out.printf("The count of the primes up to %,10d = %d%n", max, countPrimes(1, max));
        }
    }

    private static int countPrimes(int min, int max) {
        int count = 0;
        for ( int i = min ; i <= max ; i++ ) {
            if ( phi[i] == i-1 ) {
                count++;
            }
        }
        return count;
    }

    private static final int max = 10000000;
    private static final int[] phi = new int[max+1];

    private static final void computePhi() {
        for ( int i = 1 ; i <= max ; i++ ) {
            phi[i] = i;
        }
        for ( int i = 2 ; i <= max ; i++ ) {
            if (phi[i] < i) continue;
            for ( int j = i ; j <= max ; j += i ) {
                phi[j] -= phi[j] / i;
            }
        }
    }

}
