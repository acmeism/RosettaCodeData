static class Task3
{
    public static float SiegfriedRumpSingle(float a, float b)
    {
        float
            a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2
            ;

        // Non-integral literals must be coerced to single using the type suffix.
        return 333.75f * b6 +
            (a2 * (
                11 * a2 * b2 -
                b6 -
                121 * b4 -
                2)) +
            5.5f * b4 * b4 +
            a / (2 * b);
    }

    public static double SiegfriedRumpDouble(double a, double b)
    {
        double
            a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2
            ;

        // Non-integral literals are doubles by default.
        return
            333.75 * b6
            + a2 * (
                11 * a2 * b * b
                - b6
                - 121 * b4
                - 2)
            + 5.5 * b4 * b4
            + a / (2 * b);
    }

    public static decimal SiegfriedRumpDecimal(decimal a, decimal b)
    {
        decimal
            a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2
            ;

        // The same applies for decimal.
        return
            333.75m * b6
            + a2 * (
                11 * a2 * b * b
                - b6
                - 121 * b4
                - 2)
            + 5.5m * b4 * b4
            + a / (2 * b);
    }

#if USE_BIGRATIONAL
    public static BigRational SiegfriedRumpRational(BigRational a, BigRational b)
    {
        // Use mixed number constructor to maintain exact precision (333+3/4, 5+1/2).
        var c1 = new BigRational(33375, 100);
        var c2 = new BigRational(55, 10);

        return c1 * BigRational.Pow(b, 6)
            + (a * a * (
                11 * a * a * b * b
                - BigRational.Pow(b, 6)
                - 121 * BigRational.Pow(b, 4)
                - 2))
            + c2 * BigRational.Pow(b, 8)
            + a / (2 * b);
    }
#else
    public static IEnumerable<BigRational> SiegfriedRumpRational()
    {
        while (true) yield return default;
    }
#endif

    public static void SiegfriedRump()
    {
        Console.WriteLine("Siegfried Rump Formula");
        int a = 77617;
        int b = 33096;

        Console.Write("Single: ");
        float sn = SiegfriedRumpSingle(a, b);
        Console.WriteLine("{0:G9}", sn);
        Console.WriteLine();

        Console.Write("Double: ");
        double db = SiegfriedRumpDouble(a, b);
        Console.WriteLine("{0:G17}", db);
        Console.WriteLine();

        Console.WriteLine("Decimal:");
        decimal dm = 0;
        try
        {
            dm = SiegfriedRumpDecimal(a, b);
        }
        catch (OverflowException ex)
        {
            Console.WriteLine("Exception: " + ex.Message);
        }
        Console.WriteLine($"  {dm}");
        Console.WriteLine();

        Console.WriteLine("BigRational:");
        BigRational br = SiegfriedRumpRational(a, b);
        Console.WriteLine($"  Rounded: {(decimal)br}");
        Console.WriteLine($"  Exact: {br}");
    }
}
