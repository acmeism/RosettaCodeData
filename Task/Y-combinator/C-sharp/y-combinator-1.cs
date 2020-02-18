using System;

static class YCombinator<T, TResult>
{
    // RecursiveFunc is not needed to call Fix() and so can be private.
    private delegate Func<T, TResult> RecursiveFunc(RecursiveFunc r);

    public static Func<Func<Func<T, TResult>, Func<T, TResult>>, Func<T, TResult>> Fix { get; } =
        f => ((RecursiveFunc)(g => f(x => g(g)(x))))(g => f(x => g(g)(x)));
}

static class Program
{
    static void Main()
    {
        var fac = YCombinator<int, int>.Fix(f => x => x < 2 ? 1 : x * f(x - 1));
        var fib = YCombinator<int, int>.Fix(f => x => x < 2 ? x : f(x - 1) + f(x - 2));

        Console.WriteLine(fac(10));
        Console.WriteLine(fib(10));
    }
}
