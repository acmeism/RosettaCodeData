using System;
using System.Collections.Generic;
using System.Linq;

public class JordanPolyaNumbers
{
    private static SortedSet<long> jordanPolyaSet = new SortedSet<long>();
    private static Dictionary<long, SortedDictionary<int, int>> decompositions = new Dictionary<long, SortedDictionary<int, int>>();

    public static void Main(string[] args)
    {
        CreateJordanPolya();

        long belowHundredMillion = jordanPolyaSet.LastOrDefault(x => x < 100_000_000L);
        List<long> jordanPolya = new List<long>(jordanPolyaSet);

        Console.WriteLine("The first 50 Jordan-Polya numbers:");
        for (int i = 0; i < 50; i++)
        {
            Console.Write($"{jordanPolya[i],5}{(i % 10 == 9 ? "\n" : "")}");
        }
        Console.WriteLine();

        Console.WriteLine("The largest Jordan-Polya number less than 100 million: " + belowHundredMillion);
        Console.WriteLine();

        foreach (int i in new List<int> { 800, 1050, 1800, 2800, 3800 })
        {
            Console.WriteLine($"The {i}th Jordan-Polya number is: {jordanPolya[i - 1]} = {ToString(decompositions[jordanPolya[i - 1]])}");
        }
    }

    private static void CreateJordanPolya()
    {
        jordanPolyaSet.Add(1L);
        SortedSet<long> nextSet = new SortedSet<long>();
        decompositions[1L] = new SortedDictionary<int, int>();
        long factorial = 1;

        for (int multiplier = 2; multiplier <= 20; multiplier++)
        {
            factorial *= multiplier;
            foreach (long number in new SortedSet<long>(jordanPolyaSet))
            {
                long newNumber = number;
                while (newNumber <= long.MaxValue / factorial)
                {
                    long original = newNumber;
                    newNumber *= factorial;
                    nextSet.Add(newNumber);

                    decompositions[newNumber] = new SortedDictionary<int, int>(decompositions[original]);
                    if (decompositions[newNumber].ContainsKey(multiplier))
                    {
                        decompositions[newNumber][multiplier]++;
                    }
                    else
                    {
                        decompositions[newNumber][multiplier] = 1;
                    }
                }
            }
            jordanPolyaSet.UnionWith(nextSet);
            nextSet.Clear();
        }
    }

    private static string ToString(SortedDictionary<int, int> map)
    {
        string result = "";
        foreach (int key in map.Keys)
        {
            result = key + "!" + (map[key] == 1 ? "" : "^" + map[key]) + " * " + result;
        }
        return result.TrimEnd(' ', '*');
    }
}
