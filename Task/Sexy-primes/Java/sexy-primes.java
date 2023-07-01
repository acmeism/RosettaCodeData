import java.util.ArrayList;
import java.util.List;

public class SexyPrimes {

    public static void main(String[] args) {
        sieve();
        int pairs = 0;
        List<String> pairList = new ArrayList<>();
        int triples = 0;
        List<String> tripleList = new ArrayList<>();
        int quadruplets = 0;
        List<String> quadrupletList = new ArrayList<>();
        int unsexyCount = 1;  //  2 (the even prime) not found in tests below.
        List<String> unsexyList = new ArrayList<>();
        for ( int i = 3 ; i < MAX ; i++ ) {
            if ( i-6 >= 3 && primes[i-6] && primes[i] ) {
                pairs++;
                pairList.add((i-6) + " " + i);
                if ( pairList.size() > 5 ) {
                    pairList.remove(0);
                }
            }
            else if ( i < MAX-2 && primes[i] && ! (i+6<MAX && primes[i] && primes[i+6])) {
                unsexyCount++;
                unsexyList.add("" + i);
                if ( unsexyList.size() > 10 ) {
                    unsexyList.remove(0);
                }
            }
            if ( i-12 >= 3 && primes[i-12] && primes[i-6] && primes[i] ) {
                triples++;
                tripleList.add((i-12) + " " + (i-6) + " " + i);
                if ( tripleList.size() > 5 ) {
                    tripleList.remove(0);
                }
            }
            if ( i-16 >= 3 && primes[i-18] && primes[i-12] && primes[i-6] && primes[i] ) {
                quadruplets++;
                quadrupletList.add((i-18) + " " + (i-12) + " " + (i-6) + " " + i);
                if ( quadrupletList.size() > 5 ) {
                    quadrupletList.remove(0);
                }
            }
        }
        System.out.printf("Count of sexy triples less than %,d = %,d%n", MAX, pairs);
        System.out.printf("The last 5 sexy pairs:%n  %s%n%n", pairList.toString().replaceAll(", ", "], ["));
        System.out.printf("Count of sexy triples less than %,d = %,d%n", MAX, triples);
        System.out.printf("The last 5 sexy triples:%n  %s%n%n", tripleList.toString().replaceAll(", ", "], ["));
        System.out.printf("Count of sexy quadruplets less than %,d = %,d%n", MAX, quadruplets);
        System.out.printf("The last 5 sexy quadruplets:%n  %s%n%n", quadrupletList.toString().replaceAll(", ", "], ["));
        System.out.printf("Count of unsexy primes less than %,d = %,d%n", MAX, unsexyCount);
        System.out.printf("The last 10 unsexy primes:%n  %s%n%n", unsexyList.toString().replaceAll(", ", "], ["));
    }

    private static int MAX = 1_000_035;
    private static boolean[] primes = new boolean[MAX];

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
