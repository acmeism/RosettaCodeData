using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public sealed class SturmianWord
{
    public static void Main(string[] args)
    {
        string sturmian = SturmianWordRational(13, 21);
        Console.WriteLine(sturmian + " from rational number 13 / 21");

        Console.WriteLine(SturmianWordQuadratic(1, 5, -1, 2, 8)
            + " from real number ( √5 - 1 ) / 2, the first 8 letters");

        string fibonacci = FibonacciWord(10);
        Console.WriteLine("Sturmian word equals Fibonacci word? : "
            + sturmian.Equals(fibonacci.Substring(0, sturmian.Length)));
    }

    // Return the Sturmian word for the strictly positive rational number m / n
    private static string SturmianWordRational(int m, int n)
    {
        if (m > n)
        {
            return string.Concat(SturmianWordRational(n, m).Select(c => c == '0' ? '1' : '0'));
        }

        StringBuilder sturmian = new StringBuilder();
        int k = 1;
        while ((k * m) % n != 0)
        {
            int previousFloor = (k - 1) * m / n;
            int currentFloor = (k * m) / n;
            sturmian.Append(previousFloor == currentFloor ? "0" : "10");
            k += 1;
        }
        return sturmian.ToString();
    }

    // Return the first 'letterCount' letters of Sturmian word for the strictly positive real number
    // ( b * √(a) + m ) / n, where a is not a perfect square
    private static string SturmianWordQuadratic(int b, int a, int m, int n, int letterCount)
    {
        List<int> p = new List<int> { 0, 1 };
        List<int> q = new List<int> { 1, 0 };
        double remainder = (b * Math.Sqrt(a) + m) / (double)n;

        for (int i = 1; i <= letterCount; i++)
        {
            int integerPart = (int)remainder;
            double fractionPart = remainder - integerPart;
            int pn = integerPart * p[p.Count - 1] + p[p.Count - 2];
            int qn = integerPart * q[q.Count - 1] + q[q.Count - 2];
            p.Add(pn);
            q.Add(qn);
            remainder = 1.0 / fractionPart;
        }
        return SturmianWordRational(p[p.Count - 1], q[q.Count - 1]);
    }

    // Return the Fibonacci word for the given integer
    // @see https://en.wikipedia.org/wiki/Fibonacci_word
    private static string FibonacciWord(int number)
    {
        string previous = "0";
        string result = "01";
        for (int i = 2; i < number; i++)
        {
            string temp = result;
            result += previous;
            previous = temp;
        }
        return result;
    }
}
