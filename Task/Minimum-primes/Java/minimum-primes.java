import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.IntStream;

public final class MinimumPrimes {

  public static void main(String[] args) {
    List<Integer> numbers1 = List.of(  5, 45, 23, 21, 67 );
    List<Integer> numbers2 = List.of( 43, 22, 78, 46, 38 );
    List<Integer> numbers3 = List.of(  9, 98, 12, 54, 53 );

    List<Integer> primes = new ArrayList<Integer>();
    IntStream.range(0, 5).forEach( i -> {
      final int max = List.of( numbers1.get(i), numbers2.get(i), numbers3.get(i) ).stream()
                      .max(Comparator.naturalOrder()).get();
      primes.addLast(nextPrime(max));

    });
    System.out.println(primes);
  }

  private static int nextPrime(int number) {
      int divisor = 2;
      while ( divisor * divisor <= number ) {
          if ( number % divisor == 0 ) {
            number += 1;
            divisor = 2;
          } else {
            divisor += 1;
          }
      }
      return number;
  }

}
