using System;
using System.Collections.Generic;
using System.Linq;

public class NoConnection
{
    // adopted from Go
    static int[][] links = new int[][] {
        new int[] {2, 3, 4}, // A to C,D,E
        new int[] {3, 4, 5}, // B to D,E,F
        new int[] {2, 4},    // D to C, E
        new int[] {5},       // E to F
        new int[] {2, 3, 4}, // G to C,D,E
        new int[] {3, 4, 5}, // H to D,E,F
    };

    static int[] pegs = new int[8];

    public static void Main(string[] args)
    {
        List<int> vals = Enumerable.Range(1, 8).ToList();
        Random rng = new Random();

        do
        {
            vals = vals.OrderBy(a => rng.Next()).ToList();
            for (int i = 0; i < pegs.Length; i++)
                pegs[i] = vals[i];

        } while (!Solved());

        PrintResult();
    }

    static bool Solved()
    {
        for (int i = 0; i < links.Length; i++)
            foreach (int peg in links[i])
                if (Math.Abs(pegs[i] - peg) == 1)
                    return false;
        return true;
    }

    static void PrintResult()
    {
        Console.WriteLine($"  {pegs[0]} {pegs[1]}");
        Console.WriteLine($"{pegs[2]} {pegs[3]} {pegs[4]} {pegs[5]}");
        Console.WriteLine($"  {pegs[6]} {pegs[7]}");
    }
}
