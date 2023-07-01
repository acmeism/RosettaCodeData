using System;

delegate int Func(int i);
delegate Func FuncFunc(Func f);
delegate Func RecursiveFunc(RecursiveFunc f);

static class Program {
    static void Main() {
        var fac = Y(almost_fac);
        var fib = Y(almost_fib);
        Console.WriteLine("fac(10) = " + fac(10));
        Console.WriteLine("fib(10) = " + fib(10));
    }

    static Func Y(FuncFunc f) {
        RecursiveFunc g = r => f(x => r(r)(x));
        return g(g);
    }

    static Func almost_fac(Func f) => x => x <= 1 ? 1 : x * f(x - 1);

    static Func almost_fib(Func f) => x => x <= 2 ? 1 : f(x - 1) + f(x - 2);
}
