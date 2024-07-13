internal class Program
{
    private static void Main(string[] args)
    {
        int sequenceCount = 0;
        List<long> primes = new();
        long primeCandidate = 1;
        Console.WriteLine("   N   Prime     Sum");

        while (primeCandidate < 1000)
        {
            if (IsPrime(primeCandidate))
            {
                sequenceCount++;
                primes.Add(primeCandidate);
                long sequenceSum = primes.Sum();

                if (IsPrime(sequenceSum))
                {
                    Console.WriteLine($"{sequenceCount,4} {primeCandidate,7} {sequenceSum,7}");
                }
            }

            primeCandidate++;
        }
    }

    public static bool IsPrime(long number)
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
}
