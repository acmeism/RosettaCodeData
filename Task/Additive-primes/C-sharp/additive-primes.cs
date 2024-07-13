internal class Program
{
    private static void Main(string[] args)
    {
        long primeCandidate = 1;
        long additivePrimeCount = 0;
        Console.WriteLine("Additive Primes");

        while (primeCandidate < 500)
        {
            if (IsAdditivePrime(primeCandidate))
            {
                additivePrimeCount++;

                Console.Write($"{primeCandidate,-3} ");

                if (additivePrimeCount % 10 == 0)
                {
                    Console.WriteLine();
                }
            }

            primeCandidate++;
        }

        Console.WriteLine();
        Console.WriteLine($"Found {additivePrimeCount} additive primes less than 500");
    }

    private static bool IsAdditivePrime(long number)
    {
        if (IsPrime(number) && IsPrime(DigitSum(number)))
        {
            return true;
        }

        return false;
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

    private static long DigitSum(long n)
    {
        long sum = 0;

        while (n > 0)
        {
            sum += n % 10;
            n /= 10;
        }

        return sum;
    }
}
