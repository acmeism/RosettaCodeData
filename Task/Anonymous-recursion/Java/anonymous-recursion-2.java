import java.util.function.Function;

@FunctionalInterface
interface SelfApplicable<OUTPUT> {
  OUTPUT apply(SelfApplicable<OUTPUT> input);
}

class Utils {
  public static <INPUT, OUTPUT> SelfApplicable<Function<Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>>, Function<INPUT, OUTPUT>>> y() {
    return y -> f -> x -> f.apply(y.apply(y).apply(f)).apply(x);
  }

  public static <INPUT, OUTPUT> Function<Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>>, Function<INPUT, OUTPUT>> fix() {
    return Utils.<INPUT, OUTPUT>y().apply(Utils.<INPUT, OUTPUT>y());
  }

  public static long fib(int m) {
    if (m < 0)
      throw new IllegalArgumentException("n can not be a negative number");
    return Utils.<Integer, Long>fix().apply(
      f -> n -> (n < 2) ? n : (f.apply(n - 1) + f.apply(n - 2))
    ).apply(m);
  }
}
