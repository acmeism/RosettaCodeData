using System;

using FuncFunc = System.Func<System.Func<int, int>, System.Func<int, int>>;

static class Program {
    struct RecursiveFunc<F> {
        public Func<RecursiveFunc<F>, F> o;
    }

    static Func<A, B> Y<A, B>(Func<Func<A, B>, Func<A, B>> f) {
        var r = new RecursiveFunc<Func<A, B>> {
            o = w => f(x => w.o(w)(x))
        };
        return r.o(r);
    }

    static FuncFunc almost_fac = f => n => n <= 1 ? 1 : n * f(n - 1);

    static FuncFunc almost_fib = f => n => n <= 2 ? 1 : f(n - 1) + f(n - 2);

    static void Main() {
        var fib = Y(almost_fib);
        var fac = Y(almost_fac);
        Console.WriteLine("fib(10) = " + fib(10));
        Console.WriteLine("fac(10) = " + fac(10));
    }
}
