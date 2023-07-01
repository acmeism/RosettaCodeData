import java.util.Arrays;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.IntUnaryOperator;
import java.util.function.UnaryOperator;
import java.util.stream.Stream;

@FunctionalInterface
public interface PartialApplication<INPUT1, INPUT2, OUTPUT> extends BiFunction<INPUT1, INPUT2, OUTPUT> {
  // Original method fs(f, s).
  public static int[] fs(IntUnaryOperator f, int[] s) {
    return Arrays.stream(s)
      .parallel()
      .map(f::applyAsInt)
      .toArray()
    ;
  }

  // Currying method f.apply(a).apply(b),
  // in lieu of f.apply(a, b),
  // necessary for partial application.
  public default Function<INPUT2, OUTPUT> apply(INPUT1 input1) {
    return input2 -> apply(input1, input2);
  }

  // Original method fs turned into a partially-applicable function.
  public static final PartialApplication<IntUnaryOperator, int[], int[]> fs = PartialApplication::fs;

  public static final IntUnaryOperator f1 = i -> i + i;

  public static final IntUnaryOperator f2 = i -> i * i;

  public static final UnaryOperator<int[]> fsf1 = fs.apply(f1)::apply; // Partial application.

  public static final UnaryOperator<int[]> fsf2 = fs.apply(f2)::apply;

  public static void main(String... args) {
    int[][] sequences = {
      {0, 1, 2, 3},
      {2, 4, 6, 8},
    };

    Arrays.stream(sequences)
      .parallel()
      .map(array ->
        Stream.of(
          array,
          fsf1.apply(array),
          fsf2.apply(array)
        )
          .parallel()
          .map(Arrays::toString)
          .toArray()
      )
      .map(array ->
        String.format(
          String.join("\n",
            "array: %s",
            "  fsf1(array): %s",
            "  fsf2(array): %s"
          ),
          array
        )
      )
      .forEachOrdered(System.out::println)
    ;
  }
}
