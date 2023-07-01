static class YCombinator
{
    private delegate Func<T, TResult> RecursiveFunc<T, TResult>(RecursiveFunc<T, TResult> r);

    public static Func<T, TResult> Fix<T, TResult>(Func<Func<T, TResult>, Func<T, TResult>> f)
        => ((RecursiveFunc<T, TResult>)(g => f(x => g(g)(x))))(g => f(x => g(g)(x)));
}
