public static long recFibN(final int n)
{
 return (n < 2) ? n : recFibN(n - 1) + recFibN(n - 2);
}
