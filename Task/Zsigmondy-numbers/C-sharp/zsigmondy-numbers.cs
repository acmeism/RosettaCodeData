internal class Program
{
    private static void Main(string[] args)
    {
        //record Pair(int a, int b) { }
        List<KeyValuePair<int, int>> pairs =
        [
            KeyValuePair.Create(2, 1),
            KeyValuePair.Create(3, 1),
            KeyValuePair.Create(4, 1),
            KeyValuePair.Create(5, 1),
            KeyValuePair.Create(6, 1),
            KeyValuePair.Create(7, 1),
            KeyValuePair.Create(3, 2),
            KeyValuePair.Create(5, 3),
            KeyValuePair.Create(7, 3),
            KeyValuePair.Create(7, 5),
        ];

        foreach (KeyValuePair<int, int> pair in pairs)
        {
            Console.WriteLine("Zsigmondy(n, " + pair.Key + ", " + pair.Value + ")");

            for (int n = 1; n <= 18; n++)
            {
                Console.Write(ZsigmondyNumber(n, pair.Key, pair.Value) + " ");
            }

            Console.WriteLine();
        }
    }

    private static long ZsigmondyNumber(int n, int a, int b)
    {
        long dn = (long)(Math.Pow(a, n) - Math.Pow(b, n));

        if (IsPrime(dn))
        {
            return dn;
        }

        List<long> divisors = Divisors(dn);

        for (int m = 1; m < n; m++)
        {
            long dm = (long)(Math.Pow(a, m) - Math.Pow(b, m));
            divisors.RemoveAll(d => GCD(dm, d) > 1);
        }

        return divisors[divisors.Count() - 1];
    }

    private static List<long> Divisors(long number)
    {
        List<long> result = new List<long>();
        for (long d = 1; d * d <= number; d++)
        {
            if (number % d == 0)
            {
                result.Add(d);

                if (d * d < number)
                {
                    result.Add(number / d);
                }
            }
        }

        result.Sort();
        return result;
    }

    private static bool IsPrime(long number)
    {
        if (number < 2)
        {
            return false;
        }

        if (number % 2 == 0)
        {
            return number == 2;
        }

        if (number % 3 == 0)
        {
            return number == 3;
        }

        int delta = 2;
        long k = 5;

        while (k * k <= number)
        {
            if (number % k == 0)
            {
                return false;
            }

            k += delta;
            delta = 6 - delta;
        }

        return true;
    }

    private static long GCD(long a, long b)
    {
        while (b != 0)
        {
            long temp = a; a = b; b = temp % b;
        }

        return a;
    }
}
