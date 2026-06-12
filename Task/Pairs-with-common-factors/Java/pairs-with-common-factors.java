import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class PairsWithCommonFactors {

  public static void main(String[] args) {
    final int maximum = 1_000_000;
    listPrimeNumbers(maximum);
    listTotients(maximum);
    long[] pairsCount = new long[maximum + 1];
    long totientSum = 0;

    for ( int number = 1; number <= maximum; number++ ) {
      totientSum += totients[number];
      if ( Collections.binarySearch(primes, number) > 0 ) {
        pairsCount[number] = pairsCount[number - 1];
      } else {
        pairsCount[number] = ( (long) number * ( number - 1 ) >> 1 ) - totientSum + 1;
      }
    }

    System.out.println("The first one hundred terms of the number of pairs with common factors:");
    for ( int number = 1; number <= 100; number++ ) {
      System.out.print(String.format("%4d%s", pairsCount[number], ( ( number % 10 == 0 ) ? "\n" : " " )));
    }
    System.out.println();

    int term = 1;
    while ( term <= maximum ) {
      System.out.println(String.format("%-14s%s", "Term " + term + ": ", pairsCount[term]));
        term *= 10;
    }
  }

  private static void listTotients(int maximum) {
    totients = new int[maximum + 1];
    for ( int i = 0; i <= maximum; i++ ) {
      totients[i] = i;
    }

    for ( int i = 2; i <= maximum; i++ ) {
      if ( totients[i] == i ) {
        totients[i] = i - 1;
        for ( int j = i * 2; j <= maximum; j += i ) {
          totients[j] = ( totients[j] / i ) * ( i - 1 );
        }
      }
    }
  }

  private static void listPrimeNumbers(int maximum) {
    final int halfMaximum = ( maximum + 1 ) / 2;
    boolean[] composite = new boolean[halfMaximum];
    for ( int i = 1, p = 3; i < halfMaximum; p += 2, i++ ) {
      if ( ! composite[i] ) {
        for ( int j = i + p; j < halfMaximum; j += p ) {
          composite[j] = true;
        }
      }
    }

    primes = new ArrayList<Integer>(List.of( 2 ));
    for ( int i = 1, p = 3; i < halfMaximum; p += 2, i++ ) {
      if ( ! composite[i] ) {
        primes.add(p);
      }
    }
  }

  private static int[] totients;
  private static List<Integer> primes;

}
