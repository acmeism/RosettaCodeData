static class YCombinator
{
    static Func<T, TResult> Fix<T, TResult>(Func<Func<T, TResult>, Func<T, TResult>> f) => x => f(Fix(f))(x);
}
