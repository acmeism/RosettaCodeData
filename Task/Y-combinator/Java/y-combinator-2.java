import java.util.function.Function;

public class YCombinator {
    interface RecursiveFunc<F> extends Function<RecursiveFunc<F>, F> { }
    public static <A,B> Function<A,B> fix(Function<Function<A,B>, Function<A,B>> f) {
        RecursiveFunc<Function<A,B>> r = w -> f.apply(x -> w.apply(w).apply(x));
        return r.apply(r);
    }

    public static void main(String[] args) {
        Function<Integer,Integer> fib = fix(f -> n -> {
		if (n <= 2) return 1;
		return f.apply(n - 1) + f.apply(n - 2);
            });
        Function<Integer,Integer> fac = fix(f -> n -> {
		if (n <= 1) return 1;
		return n * f.apply(n - 1);
	    });

        System.out.println("fib(10) = " + fib.apply(10));
        System.out.println("fac(10) = " + fac.apply(10));
    }
}
