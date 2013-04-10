using System;
class Program
{
    static void Main()
    {
        double n;
        for (int t = 1; t <= 100; ++t)
                Console.WriteLine(t + ": " + (((n = Math.Sqrt(t)) == (int)n) ? "Open" : "Closed"));
    }
}
