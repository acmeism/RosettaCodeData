T BinomialCoeff(T)(in T n, in T k)
{
    T nn = n, kk = k, c = cast(T)1;

    if (kk > nn - kk) kk = nn - kk;

    for (T i = cast(T)0; i < kk; i++)
    {
        c = c * (nn - i);
        c = c / (i + cast(T)1);
    }

    return c;
}

void main()
{
    import std.stdio, std.bigint;

    BinomialCoeff(10UL, 3UL).writeln;
    BinomialCoeff(100.BigInt, 50.BigInt).writeln;
}
