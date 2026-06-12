// Sum of square and cube digits of an integer are primes
using System;

public class SumOfEtc
{
    static bool IsPrime(int num)
    {
        if (num < 2)
            return false;
        if (num == 2)
            return true;
        if (num % 2 == 0)
            return false;
        for (int i = 3; i * i <= num; i += 2)
            if (num % i == 0)
                return false;
        return true;
    }

    static int SumDigits(int num)
    {
        int sum = 0;
        while (num != 0)
        {
            sum += num % 10;
            num /= 10;
        }
        return sum;
    }

    public static void Main(string[] args)
    {
        for (int n = 0; n <= 99; n++)
            if (IsPrime(SumDigits(n * n)) && IsPrime(SumDigits(n * n * n)))
                Console.Write(n + " ");
        Console.WriteLine();
    }
}
