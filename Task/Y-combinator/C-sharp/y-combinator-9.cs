using System;

// Func and FuncFunc can be defined using using aliases and the System.Func<T, TReult> type, but RecursiveFunc must be a delegate type of its own.
using Func = System.Func<int, int>;
using FuncFunc = System.Func<System.Func<int, int>, System.Func<int, int>>;

delegate Func RecursiveFunc(RecursiveFunc f);

static class Program {
    static void Main() {
        var fac = Y(almost_fac);
        var fib = Y(almost_fib);
        Console.WriteLine("fac(10) = " + fac(10));
        Console.WriteLine("fib(10) = " + fib(10));
    }

    static Func Y(FuncFunc f) {
        RecursiveFunc g = delegate (RecursiveFunc r) {
            return f(delegate (int x) {
                return r(r)(x);
            });
        };
        return g(g);
    }

    static Func almost_fac(Func f) {
        return delegate (int x) {
            if (x <= 1) {
                return 1;
            }
            return x * f(x-1);
        };
    }

    static Func almost_fib(Func f) {
        return delegate (int x) {
            if (x <= 2) {
                return 1;
            }
            return f(x-1)+f(x-2);
        };
    }
}
