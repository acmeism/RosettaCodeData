import java.util.function.Function;

@FunctionalInterface
interface SelfApplicable<OUTPUT> {
  OUTPUT apply(SelfApplicable<OUTPUT> input);
}

class Utils {
  public static <INPUT, OUTPUT> SelfApplicable<Function<Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>>, Function<INPUT, OUTPUT>>> y(Class<INPUT> input, Class<OUTPUT> output) {
    return y -> f -> x -> f.apply(y.apply(y).apply(f)).apply(x);
  }

  public static <INPUT, OUTPUT> Function<Function<Function<INPUT, OUTPUT>, Function<INPUT, OUTPUT>>, Function<INPUT, OUTPUT>> fix(Class<INPUT> input, Class<OUTPUT> output) {
    return y(input, output).apply(y(input, output));
  }

  public static long fib(int m) {
    if (m < 0)
      throw new IllegalArgumentException("n can not be a negative number");
    return fix(Integer.class, Long.class).apply(
      f -> n -> (n < 2) ? n : (f.apply(n - 1) + f.apply(n - 2))
    ).apply(m);
  }
}
