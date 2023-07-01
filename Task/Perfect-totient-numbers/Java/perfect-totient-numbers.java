import java.util.ArrayList;
import java.util.List;

public class PerfectTotientNumbers {

    public static void main(String[] args) {
        computePhi();
        int n = 20;
        System.out.printf("The first %d perfect totient numbers:%n%s%n", n, perfectTotient(n));
    }

    private static final List<Integer> perfectTotient(int n) {
        int test = 2;
        List<Integer> results = new ArrayList<Integer>();
        for ( int i = 0 ; i < n ; test++ ) {
            int phiLoop = test;
            int sum = 0;
            do {
                phiLoop = phi[phiLoop];
                sum += phiLoop;
            } while ( phiLoop > 1);
            if ( sum == test ) {
                i++;
                results.add(test);
            }
        }
        return results;
    }

    private static final int max = 100000;
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
