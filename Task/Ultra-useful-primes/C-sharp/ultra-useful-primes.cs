using System.Numerics;
using System.Security.Cryptography;

internal class Program
{
    private static void Main(string[] args)
    {
        for (int i = 1; i <= 10; i++)
        {
            Console.WriteLine(GetUltraUsefulPrime(i));
        }

    }
    public static int GetUltraUsefulPrime(int n)
    {
        int k = 1;

        BigInteger num = BigInteger.Pow(2, (int)Math.Pow(2, n));

        while (!IsProbablePrime(num - k, 20))
        {
            k += 2;
        }

        return k;
    }

    // Miller-Rabin primality from this site
    public static bool IsProbablePrime(BigInteger source, int certainty)
    {
        if (source == 2 || source == 3)
            return true;
        if (source < 2 || source % 2 == 0)
            return false;

        BigInteger d = source - 1;
        int s = 0;

        while (d % 2 == 0)
        {
            d /= 2;
            s += 1;
        }

        // There is no built-in method for generating random BigInteger values.
        // Instead, random BigIntegers are constructed from randomly generated
        // byte arrays of the same length as the source.
        RandomNumberGenerator rng = RandomNumberGenerator.Create();
        byte[] bytes = new byte[source.ToByteArray().LongLength];
        BigInteger a;

        for (int i = 0; i < certainty; i++)
        {
            do
            {
                // This may raise an exception in Mono 2.10.8 and earlier.
                // http://bugzilla.xamarin.com/show_bug.cgi?id=2761
                rng.GetBytes(bytes);
                a = new BigInteger(bytes);
            }
            while (a < 2 || a >= source - 2);

            BigInteger x = BigInteger.ModPow(a, d, source);
            if (x == 1 || x == source - 1)
                continue;

            for (int r = 1; r < s; r++)
            {
                x = BigInteger.ModPow(x, 2, source);
                if (x == 1)
                    return false;
                if (x == source - 1)
                    break;
            }

            if (x != source - 1)
                return false;
        }

        return true;
    }
}
