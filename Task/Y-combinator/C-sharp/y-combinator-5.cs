using Func = System.Func<int, int>;
using FuncFunc = System.Func<System.Func<int, int>, System.Func<int, int>>;

static class Program {
    struct RecursiveFunc<F> {
        public System.Func<RecursiveFunc<F>, F> o;
    }

    static System.Func<A, B> Y<A, B>(System.Func<System.Func<A, B>, System.Func<A, B>> f) {
        var r = new RecursiveFunc<System.Func<A, B>>() {
            o = new System.Func<RecursiveFunc<System.Func<A, B>>, System.Func<A, B>>((RecursiveFunc<System.Func<A, B>> w) => {
                return f(new System.Func<A, B>((A x) => {
                    return w.o(w)(x);
                }));
            })
        };
        return r.o(r);
    }

    static FuncFunc almost_fac = (Func f) => {
        return new Func((int n) => {
            if (n <= 1) return 1;
            return n * f(n - 1);
        });
    };

    static FuncFunc almost_fib = (Func f) => {
        return new Func((int n) => {
            if (n <= 2) return 1;
            return f(n - 1) + f(n - 2);
        });
    };

    static int Main() {
        var fib = Y(almost_fib);
        var fac = Y(almost_fac);
        System.Console.WriteLine("fib(10) = " + fib(10));
        System.Console.WriteLine("fac(10) = " + fac(10));
        return 0;
    }
}
