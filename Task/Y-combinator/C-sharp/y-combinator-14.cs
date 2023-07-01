using System;

static class YCombinator {
    interface Function<T, R> {
        R apply(T t);
    }

    interface RecursiveFunction<F> : Function<RecursiveFunction<F>, F> {
    }

    static class Y<A, B> {
        class __1 : RecursiveFunction<Function<A, B>> {
            class __2 : Function<A, B> {
                readonly RecursiveFunction<Function<A, B>> w;

                public __2(RecursiveFunction<Function<A, B>> w) {
                    this.w = w;
                }

                public B apply(A x) {
                    return w.apply(w).apply(x);
                }
            }

            Function<Function<A, B>, Function<A, B>> f;

            public __1(Function<Function<A, B>, Function<A, B>> f) {
                this.f = f;
            }

            public Function<A, B> apply(RecursiveFunction<Function<A, B>> w) {
                return f.apply(new __2(w));
            }
        }

        public static Function<A, B> _(Function<Function<A, B>, Function<A, B>> f) {
            var r = new __1(f);
            return r.apply(r);
        }
    }

    class __1 : Function<Function<int, int>, Function<int, int>> {
        class __2 : Function<int, int> {
            readonly Function<int, int> f;

            public __2(Function<int, int> f) {
                this.f = f;
            }

            public int apply(int n) {
                return
                    (n <= 2)
                  ? 1
                  : (f.apply(n - 1) + f.apply(n - 2));
            }
        }

        public Function<int, int> apply(Function<int, int> f) {
            return new __2(f);
        }
    }

    class __2 : Function<Function<int, int>, Function<int, int>> {
        class __3 : Function<int, int> {
            readonly Function<int, int> f;

            public __3(Function<int, int> f) {
                this.f = f;
            }

            public int apply(int n) {
                return
                    (n <= 1)
                  ? 1
                  : (n * f.apply(n - 1));
            }
        }

        public Function<int, int> apply(Function<int, int> f) {
            return new __3(f);
        }
    }

    static void Main(params String[] arguments) {
        Function<int, int> fib = Y<int, int>._(new __1());
        Function<int, int> fac = Y<int, int>._(new __2());

        Console.WriteLine("fib(10) = " + fib.apply(10));
        Console.WriteLine("fac(10) = " + fac.apply(10));
    }
}
