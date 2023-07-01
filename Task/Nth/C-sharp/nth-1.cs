using System;
using System.Linq;

class Program
{
    private static string Ordinalize(int i)
    {
        i = Math.Abs(i);

        if (new[] {11, 12, 13}.Contains(i%100))
            return i + "th";

        switch (i%10)
        {
            case 1:
                return i + "st";
            case 2:
                return i + "nd";
            case 3:
                return i + "rd";
            default:
                return i + "th";
        }
    }

    static void Main()
    {
        Console.WriteLine(string.Join(" ", Enumerable.Range(0, 26).Select(Ordinalize)));
        Console.WriteLine(string.Join(" ", Enumerable.Range(250, 16).Select(Ordinalize)));
        Console.WriteLine(string.Join(" ", Enumerable.Range(1000, 26).Select(Ordinalize)));
    }
}
