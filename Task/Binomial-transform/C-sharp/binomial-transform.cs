using System;

public static class BinomialTransform
{
    public static void Main()
    {
        long[][] sequences = new long[][]
        {
            new long[] { 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845 },
            new long[] { 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0 },
            new long[] { 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181 },
            new long[] { 1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37 }
        };
        string[] names = new string[]
        {
            "Catalan number sequence:",
            "Prime flip-flop sequence:",
            "Fibonacci number sequence:",
            "Padovan number sequence:"
        };

        for (int i = 0; i < sequences.Length; i++)
        {
            Console.WriteLine(names[i]);
            Console.WriteLine("[" + string.Join(", ", sequences[i]) + "]");
            Console.WriteLine("Forward binomial transform:");
            Console.WriteLine("[" + string.Join(", ", Forward(sequences[i])) + "]");
            Console.WriteLine("Inverse binomial transform:");
            Console.WriteLine("[" + string.Join(", ", Inverse(sequences[i])) + "]");
            Console.WriteLine("Round trip:");
            Console.WriteLine("[" + string.Join(", ", Inverse(Forward(sequences[i]))) + "]");
            Console.WriteLine("Self-inverting:");
            Console.WriteLine("[" + string.Join(", ", SelfInverting(sequences[i])) + "]");
            Console.WriteLine("Round trip self-inverting:");
            Console.WriteLine("[" + string.Join(", ", SelfInverting(SelfInverting(sequences[i]))) + "]");
            Console.WriteLine();
        }
    }

    private static long[] SelfInverting(long[] numbers)
    {
        long[] transform = new long[numbers.Length];
        for (int n = 0; n < numbers.Length; n++)
        {
            for (int k = 0; k <= n; k++)
            {
                int sign = (k % 2 == 1) ? -1 : 1;
                transform[n] += Binomial(n, k) * numbers[k] * sign;
            }
        }
        return transform;
    }

    private static long[] Inverse(long[] numbers)
    {
        long[] transform = new long[numbers.Length];
        for (int n = 0; n < numbers.Length; n++)
        {
            for (int k = 0; k <= n; k++)
            {
                int sign = ((n - k) % 2 == 1) ? -1 : 1;
                transform[n] += Binomial(n, k) * numbers[k] * sign;
            }
        }
        return transform;
    }

    private static long[] Forward(long[] numbers)
    {
        long[] transform = new long[numbers.Length];
        for (int n = 0; n < numbers.Length; n++)
        {
            for (int k = 0; k <= n; k++)
            {
                transform[n] += Binomial(n, k) * numbers[k];
            }
        }
        return transform;
    }

    private static long Binomial(int n, int k)
    {
        return Factorial(n) / Factorial(n - k) / Factorial(k);
    }

    private static long Factorial(int number)
    {
        if (number > 20)
        {
            throw new ArgumentException("Factorial of number is too large: " + number);
        }
        if (number < 2)
        {
            return 1;
        }

        long factorial = 1;
        for (int i = 2; i <= number; i++)
        {
            factorial *= i;
        }
        return factorial;
    }
}

