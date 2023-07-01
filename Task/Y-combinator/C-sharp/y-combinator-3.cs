static class YCombinator<T, TResult>
{
    public static Func<Func<Func<T, TResult>, Func<T, TResult>>, Func<T, TResult>> Fix { get; } =
        f => ((Func<dynamic, Func<T, TResult>>)(g => f(x => g(g)(x))))((Func<dynamic, Func<T, TResult>>)(g => f(x => g(g)(x))));
}
