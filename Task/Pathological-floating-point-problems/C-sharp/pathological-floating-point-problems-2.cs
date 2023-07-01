static class Task1
{
    public static IEnumerable<float> SequenceSingle()
    {
        // n, n-1, and n-2
        float vn, vn_1, vn_2;
        vn_2 = 2;
        vn_1 = -4;

        while (true)
        {
            yield return vn_2;
            vn = 111f - (1130f / vn_1) + (3000f / (vn_1 * vn_2));
            vn_2 = vn_1;
            vn_1 = vn;
        }
    }

    public static IEnumerable<double> SequenceDouble()
    {
        // n, n-1, and n-2
        double vn, vn_1, vn_2;
        vn_2 = 2;
        vn_1 = -4;

        while (true)
        {
            yield return vn_2;
            vn = 111 - (1130 / vn_1) + (3000 / (vn_1 * vn_2));
            vn_2 = vn_1;
            vn_1 = vn;
        }
    }

    public static IEnumerable<decimal> SequenceDecimal()
    {
        // n, n-1, and n-2
        decimal vn, vn_1, vn_2;
        vn_2 = 2;
        vn_1 = -4;

        // Use constants to avoid calling the Decimal constructor in the loop.
        const decimal i11 = 111;
        const decimal i130 = 1130;
        const decimal E000 = 3000;

        while (true)
        {
            yield return vn_2;
            vn = i11 - (i130 / vn_1) + (E000 / (vn_1 * vn_2));
            vn_2 = vn_1;
            vn_1 = vn;
        }
    }

#if USE_BIGRATIONAL
    public static IEnumerable<BigRational> SequenceRational()
    {
        // n, n-1, and n-2
        BigRational vn, vn_1, vn_2;
        vn_2 = 2;
        vn_1 = -4;

        // Same reasoning as for decimal.
        BigRational i11 = 111;
        BigRational i130 = 1130;
        BigRational E000 = 3000;

        while (true)
        {
            yield return vn_2;
            vn = i11 - (i130 / vn_1) + (E000 / (vn_1 * vn_2));
            vn_2 = vn_1;
            vn_1 = vn;
        }
    }
#else
    public static IEnumerable<BigRational> SequenceRational()
    {
        while (true) yield return default;
    }
#endif

    static void IncreaseMaxN(ref int[] arr)
    {
        int[] tmp = new int[arr.Length + 1];
        arr.CopyTo(tmp, 0);
        tmp[arr.Length] = 1000;
        arr = tmp;
    }

    public static void WrongConvergence()
    {
        Console.WriteLine("Wrong Convergence Sequence:");

        int[] displayedIndices = { 3, 4, 5, 6, 7, 8, 20, 30, 50, 100 };
        IncreaseMaxN(ref displayedIndices);

        var indicesSet = new HashSet<int>(displayedIndices);

        Console.WriteLine(Headings);

        int n = 1;
        // Enumerate the implementations in parallel as tuples.
        foreach (var x in SequenceSingle()
            .Zip(SequenceDouble(), (sn, db) => (sn, db))
            .Zip(SequenceDecimal(), (a, dm) => (a.sn, a.db, dm))
            .Zip(SequenceRational(), (a, br) => (a.sn, a.db, a.dm, br)))
        {
            if (n > displayedIndices.Max()) break;

            if (indicesSet.Contains(n))
                Console.WriteLine(FormatOutput(n, x));

            n++;
        }
    }
}
