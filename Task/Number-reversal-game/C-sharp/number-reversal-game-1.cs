using System;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        var r = new Random();

        var tries = 1;
        var sorted = Enumerable.Range(1, 9).ToList();
        var values = sorted.OrderBy(x => r.Next(-1, 1)).ToList();

        while (Enumerable.SequenceEqual(sorted, values)) {
            values = sorted.OrderBy(x => r.Next(-1, 1)).ToList();
        }

        //values = "1 3 9 2 7 5 4 8 6".Split().Select(x => int.Parse(x)).ToList();

        while (!Enumerable.SequenceEqual(sorted, values))
        {
            Console.Write("# {0}: LIST: {1} - Flip how many? ", tries, String.Join(" ", values));

            values.Reverse(0, int.Parse(Console.ReadLine()));
            tries += 1;
        }

        Console.WriteLine("\nYou took {0} attempts to put the digits in order!", tries - 1);
        Console.ReadLine();
    }
}
