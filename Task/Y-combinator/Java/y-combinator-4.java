interface Function<A, B> {
    public B call(A x);
}

public class YCombinator {
    interface RecursiveFunc<F> extends Function<RecursiveFunc<F>, F> { }

    public static <A,B> Function<A,B> fix(final Function<Function<A,B>, Function<A,B>> f) {
        RecursiveFunc<Function<A,B>> r =
            new RecursiveFunc<Function<A,B>>() {
            public Function<A,B> call(final RecursiveFunc<Function<A,B>> w) {
                return f.call(new Function<A,B>() {
                        public B call(A x) {
                            return w.call(w).call(x);
                        }
                    });
            }
        };
        return r.call(r);
    }

    public static void main(String[] args) {
        Function<Function<Integer,Integer>, Function<Integer,Integer>> almost_fib =
            new Function<Function<Integer,Integer>, Function<Integer,Integer>>() {
            public Function<Integer,Integer> call(final Function<Integer,Integer> f) {
                return new Function<Integer,Integer>() {
                    public Integer call(Integer n) {
                        if (n <= 2) return 1;
                        return f.call(n - 1) + f.call(n - 2);
                    }
                };
            }
        };

        Function<Function<Integer,Integer>, Function<Integer,Integer>> almost_fac =
            new Function<Function<Integer,Integer>, Function<Integer,Integer>>() {
            public Function<Integer,Integer> call(final Function<Integer,Integer> f) {
                return new Function<Integer,Integer>() {
                    public Integer call(Integer n) {
                        if (n <= 1) return 1;
                        return n * f.call(n - 1);
                    }
                };
            }
        };

        Function<Integer,Integer> fib = fix(almost_fib);
        Function<Integer,Integer> fac = fix(almost_fac);

        System.out.println("fib(10) = " + fib.call(10));
        System.out.println("fac(10) = " + fac.call(10));
    }
}
