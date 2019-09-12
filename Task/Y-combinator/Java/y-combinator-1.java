import java.util.function.Function;

public interface YCombinator {
  interface RecursiveFunction<F> extends Function<RecursiveFunction<F>, F> { }
  public static <A,B> Function<A,B> Y(Function<Function<A,B>, Function<A,B>> f) {
    RecursiveFunction<Function<A,B>> r = w -> f.apply(x -> w.apply(w).apply(x));
    return r.apply(r);
  }

  public static void main(String... arguments) {
    Function<Integer,Integer> fib = Y(f -> n ->
      (n <= 2)
        ? 1
        : (f.apply(n - 1) + f.apply(n - 2))
    );
    Function<Integer,Integer> fac = Y(f -> n ->
      (n <= 1)
        ? 1
        : (n * f.apply(n - 1))
    );

    System.out.println("fib(10) = " + fib.apply(10));
    System.out.println("fac(10) = " + fac.apply(10));
  }
}
