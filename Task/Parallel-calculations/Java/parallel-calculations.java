import static java.lang.System.out;

import static java.util.Arrays.stream;
import static java.util.Comparator.comparing;

public interface ParallelCalculations {
  public static final long[] NUMBERS = {
    12757923,
    12878611,
    12878893,
    12757923,
    15808973,
    15780709,
    197622519
  };

  public static void main(String... arguments) {
    stream(NUMBERS)
      .unordered()
      .parallel()
      .mapToObj(ParallelCalculations::minimalPrimeFactor)
      .max(comparing(a -> a[0]))
      .ifPresent(res -> out.printf(
        "%d has the largest minimum prime factor: %d%n",
        res[1],
        res[0]
      ))
    ;
  }

  public static long[] minimalPrimeFactor(long n) {
    return iterate(2, i -> i + 1)
      .filter(i -> n >= i * i)
      .filter(i -> n % i == 0)
      .mapToObj(i -> new long[]{i, n})
      .findFirst()
      .orElseGet(() -> new long[]{n, n})
    ;
  }
}
