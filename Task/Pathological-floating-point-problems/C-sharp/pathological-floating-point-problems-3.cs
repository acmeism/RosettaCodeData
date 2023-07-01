static class Task2
{
    public static IEnumerable<float> ChaoticBankSocietySingle()
    {
        float balance = (float)(Math.E - 1);

        for (int year = 1; ; year++)
            yield return balance = (balance * year) - 1;
    }

    public static IEnumerable<double> ChaoticBankSocietyDouble()
    {
        double balance = Math.E - 1;

        for (int year = 1; ; year++)
            yield return balance = (balance * year) - 1;
    }

    public static IEnumerable<decimal> ChaoticBankSocietyDecimal()
    {
        // 27! is the largest factorial decimal can represent.
        decimal balance = CalculateEDecimal(27) - 1;

        for (int year = 1; ; year++)
            yield return balance = (balance * year) - 1;
    }

#if USE_BIGRATIONAL
    public static IEnumerable<BigRational> ChaoticBankSocietyRational()
    {
        // 100 iterations is precise enough for 25 years.
        BigRational brBalance = CalculateERational(100) - 1;

        for (int year = 1; ; year++)
            yield return brBalance = (brBalance * year) - 1;
    }
#else
    public static IEnumerable<BigRational> ChaoticBankSocietyRational()
    {
        while (true) yield return default;
    }
#endif

    public static decimal CalculateEDecimal(int terms)
    {
        decimal e = 1;
        decimal fact = 1;
        for (int i = 1; i <= terms; i++)
        {
            fact *= i;
            e += decimal.One / fact;
        }

        return e;
    }

#if USE_BIGRATIONAL
    public static BigRational CalculateERational(int terms)
    {
        BigRational e = 1;
        BigRational fact = 1;
        for (int i = 1; i < terms; i++)
        {
            fact *= i;
            e += BigRational.Invert(fact);
        }

        return e;
    }
#endif

    [Conditional("INCREASED_LIMITS")]
    static void InceaseMaxYear(ref int year) => year = 40;

    public static void ChaoticBankSociety()
    {
        Console.WriteLine("Chaotic Bank Society:");
        Console.WriteLine(Headings);

        int maxYear = 25;
        InceaseMaxYear(ref maxYear);

        int i = 0;
        foreach (var x in ChaoticBankSocietySingle()
            .Zip(ChaoticBankSocietyDouble(), (sn, db) => (sn, db))
            .Zip(ChaoticBankSocietyDecimal(), (a, dm) => (a.sn, a.db, dm))
            .Zip(ChaoticBankSocietyRational(), (a, br) => (a.sn, a.db, a.dm, br)))
        {
            if (i >= maxYear) break;
            Console.WriteLine(FormatOutput(i + 1, x));
            i++;
        }
    }
}
