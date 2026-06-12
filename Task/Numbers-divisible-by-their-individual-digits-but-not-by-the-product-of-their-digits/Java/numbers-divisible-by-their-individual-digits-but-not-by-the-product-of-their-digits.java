import java.util.List;
import java.util.stream.IntStream;

public final class NumbersDivisibleByTheirIndividualDigitsButNotByTheProductOfTheirDigits {

  public static void main(String[] args) {
    List<Integer> result = IntStream.range(1, 1_000).filter( n -> {
        List<Integer> digits = String.valueOf(n).chars().map(Character::getNumericValue).boxed().toList();
        if ( digits.stream().allMatch( i -> i != 0 && n % i == 0 ) ) {
            final int product = digits.stream().reduce(1, Math::multiplyExact);
            return n % product != 0;
        }
        return false;
    } ).boxed().toList();

    System.out.println("Numbers < 1,000 divisible by their digits, but not by the product thereof:");
    IntStream.range(0, result.size()).forEach( i -> {
      System.out.print("%3d%s".formatted(result.get(i), ( i % 9 == 8 ? "\n" : " " )));
    } );
  }

}
