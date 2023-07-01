using System;

static class Program {
    struct RecursiveFunc<F> {
        public Func<RecursiveFunc<F>, F> o;
    }

    static Func<A, B> Y<A, B>(Func<Func<A, B>, Func<A, B>> f) {
        var r = new RecursiveFunc<Func<A, B>> { o = w => f(_0 => w.o(w)(_0)) };
        return r.o(r);
    }

    static void Main() {
        // C# can't infer the type arguments to Y either; either it or f must be explicitly typed.
        var fac = Y((Func<int, int> f) => _0 => _0 <= 1 ? 1 : _0 * f(_0 - 1));
        var fib = Y((Func<int, int> f) => _0 => _0 <= 2 ? 1 : f(_0 - 1) + f(_0 - 2));

        Console.WriteLine($"fac(5) = {fac(5)}");
        Console.WriteLine($"fib(9) = {fib(9)}");
    }
}
