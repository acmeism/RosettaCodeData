public static long fibTailRec(final int n)
{
 return fibInner(0, 1, n);
}

private static long fibInner(final long a, final long b, final int n)
{
 return n < 1 ? a : n == 1 ?  b : fibInner(b, a + b, n - 1);
}
