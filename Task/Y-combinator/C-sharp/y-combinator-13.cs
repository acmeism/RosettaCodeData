using System;

static class Program {
    interface Function<T, R> {
        R apply(T t);
    }

    interface RecursiveFunction<F> : Function<RecursiveFunction<F>, F> {
    }

    static class Functions {
        class Function<T, R> : Program.Function<T, R> {
            readonly Func<T, R> _inner;

            public Function(Func<T, R> inner) => this._inner = inner;

            public R apply(T t) => this._inner(t);
        }

        class RecursiveFunction<F> : Function<Program.RecursiveFunction<F>, F>, Program.RecursiveFunction<F> {
            public RecursiveFunction(Func<Program.RecursiveFunction<F>, F> inner) : base(inner) {
            }
        }

        public static Program.Function<T, R> Create<T, R>(Func<T, R> inner) => new Function<T, R>(inner);
        public static Program.RecursiveFunction<F> Create<F>(Func<Program.RecursiveFunction<F>, F> inner) => new RecursiveFunction<F>(inner);
    }

    static Function<A, B> Y<A, B>(Function<Function<A, B>, Function<A, B>> f) {
        var r = Functions.Create<Function<A, B>>(w => f.apply(Functions.Create<A, B>(x => w.apply(w).apply(x))));
        return r.apply(r);
    }

    static void Main(params String[] arguments) {
        Function<int, int> fib = Y(Functions.Create<Function<int, int>, Function<int, int>>(f => Functions.Create<int, int>(n =>
            (n <= 2)
              ? 1
              : (f.apply(n - 1) + f.apply(n - 2))))
        );
        Function<int, int> fac = Y(Functions.Create<Function<int, int>, Function<int, int>>(f => Functions.Create<int, int>(n =>
            (n <= 1)
              ? 1
              : (n * f.apply(n - 1))))
        );

        Console.WriteLine("fib(10) = " + fib.apply(10));
        Console.WriteLine("fac(10) = " + fac.apply(10));
    }
}
