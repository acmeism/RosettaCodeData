static int Fib(int n)
{
    if (n < 0) throw new ArgumentException("Must be non negativ", "n");

    Func<int, int> fib = null; // Must be known, before we can assign recursively to it.
    fib = p => p > 1 ? fib(p - 2) + fib(p - 1) : p;
    return fib(n);
}
