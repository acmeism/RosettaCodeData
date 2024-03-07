using System;
using System.Collections.Generic;
using System.Linq;

public class ArithmeticNumbers
{
    public static void Main(string[] args)
    {
        int arithmeticCount = 0;
        int compositeCount = 0;
        int n = 1;

        while (arithmeticCount <= 1_000_000)
        {
            var factors = Factors(n);
            int sum = factors.Sum();
            if (sum % factors.Count == 0)
            {
                arithmeticCount++;
                if (factors.Count > 2)
                {
                    compositeCount++;
                }
                if (arithmeticCount <= 100)
                {
                    Console.Write($"{n,3}{(arithmeticCount % 10 == 0 ? "\n" : " ")}");
                }
                if (new[] { 1_000, 10_000, 100_000, 1_000_000 }.Contains(arithmeticCount))
                {
                    Console.WriteLine();
                    Console.WriteLine($"{arithmeticCount}th arithmetic number is {n}");
                    Console.WriteLine($"Number of composite arithmetic numbers <= {n}: {compositeCount}");
                }
            }
            n++;
        }
    }

    private static HashSet<int> Factors(int number)
    {
        var result = new HashSet<int> { 1, number };
        int i = 2;
        int j;
        while ((j = number / i) >= i)
        {
            if (i * j == number)
            {
                result.Add(i);
                result.Add(j);
            }
            i++;
        }
        return result;
    }
}
