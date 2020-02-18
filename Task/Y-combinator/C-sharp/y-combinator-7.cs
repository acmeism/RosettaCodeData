using System;
using System.Diagnostics;

class Program {
    public delegate TResult ParamsFunc<T, TResult>(params T[] args);

    static class Y<Result, Args> {
        class RecursiveFunction {
            public Func<RecursiveFunction, ParamsFunc<Args, Result>> o;
            public RecursiveFunction(Func<RecursiveFunction, ParamsFunc<Args, Result>> o) => this.o = o;
        }

        public static ParamsFunc<Args, Result> y1(
                Func<ParamsFunc<Args, Result>, ParamsFunc<Args, Result>> f) {

            var r = new RecursiveFunction((RecursiveFunction w)
                => f((Args[] args) => w.o(w)(args)));

            return r.o(r);
        }
    }

    static ParamsFunc<Args, Result> y2<Args, Result>(
            Func<ParamsFunc<Args, Result>, ParamsFunc<Args, Result>> f) {

        Func<dynamic, ParamsFunc<Args, Result>> r = w => {
            Debug.Assert(w is Func<dynamic, ParamsFunc<Args, Result>>);
            return f((Args[] args) => w(w)(args));
        };

        return r(r);
    }

    static ParamsFunc<Args, Result> y3<Args, Result>(
            Func<ParamsFunc<Args, Result>, ParamsFunc<Args, Result>> f)
        => (Args[] args) => f(y3(f))(args);

    static void Main() {
        var factorialY1 = Y<int, int>.y1((ParamsFunc<int, int> fact) => (int[] x)
            => (x[0] > 1) ? x[0] * fact(x[0] - 1) : 1);

        var fibY1 = Y<int, int>.y1((ParamsFunc<int, int> fib) => (int[] x)
            => (x[0] > 2) ? fib(x[0] - 1) + fib(x[0] - 2) : 2);

        Console.WriteLine(factorialY1(10)); // 362880
        Console.WriteLine(fibY1(10));       // 110
    }
}
