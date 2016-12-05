using System;
using System.Linq;

public class MapRange
{
    public static void Main() {
        foreach (int i in Enumerable.Range(0, 11))
            Console.WriteLine($"{i} maps to {Map(0, 10, -1, 0, i)}");
    }

    static double Map(double a1, double a2, double b1, double b2, double s) => b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}
