using System;
using System.Collections.Generic;

public class BlumInteger
{
    public static void Main(string[] args)
    {
        int[] blums = new int[50];
        int blumCount = 0;
        Dictionary<int, int> lastDigitCounts = new Dictionary<int, int>();
        int number = 1;

        while (blumCount < 400000)
        {
            int prime = LeastPrimeFactor(number);
            if (prime % 4 == 3)
            {
                int quotient = number / prime;
                if (quotient != prime && IsPrimeType3(quotient))
                {
                    if (blumCount < 50)
                    {
                        blums[blumCount] = number;
                    }

                    if (!lastDigitCounts.ContainsKey(number % 10))
                    {
                        lastDigitCounts[number % 10] = 0;
                    }
                    lastDigitCounts[number % 10]++;

                    blumCount++;
                    if (blumCount == 50)
                    {
                        Console.WriteLine("The first 50 Blum integers:");
                        for (int i = 0; i < 50; i++)
                        {
                            Console.Write($"{blums[i],3}");
                            Console.Write((i % 10 == 9) ? Environment.NewLine : " ");
                        }
                        Console.WriteLine();
                    }
                    else if (blumCount == 26828 || blumCount % 100000 == 0)
                    {
                        Console.WriteLine($"The {blumCount}th Blum integer is: {number}");
                        if (blumCount == 400000)
                        {
                            Console.WriteLine();
                            Console.WriteLine("Percent distribution of the first 400000 Blum integers:");
                            foreach (var key in lastDigitCounts.Keys)
                            {
                                Console.WriteLine($"    {((double)lastDigitCounts[key] / 4000):0.000}% end in {key}");
                            }
                        }
                    }
                }
            }
            number += (number % 5 == 3) ? 4 : 2;
        }
    }

    private static bool IsPrimeType3(int number)
    {
        if (number < 2) return false;
        if (number % 2 == 0) return number == 2;
        if (number % 3 == 0) return number == 3;

        for (int divisor = 5; divisor * divisor <= number; divisor += 2)
        {
            if (number % divisor == 0) return false;
        }
        return number % 4 == 3;
    }

    private static int LeastPrimeFactor(int number)
    {
        if (number == 1) return 1;
        if (number % 2 == 0) return 2;
        if (number % 3 == 0) return 3;
        if (number % 5 == 0) return 5;

        for (int divisor = 7; divisor * divisor <= number; divisor += 2)
        {
            if (number % divisor == 0) return divisor;
        }
        return number;
    }
}
