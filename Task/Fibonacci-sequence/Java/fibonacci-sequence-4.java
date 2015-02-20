public static long anFibN(final long n)
{
 double p = (1 + Math.sqrt(5)) / 2;
 double q = 1 / p;
 return (long) ((Math.pow(p, n) + Math.pow(q, n)) / Math.sqrt(5));
}
