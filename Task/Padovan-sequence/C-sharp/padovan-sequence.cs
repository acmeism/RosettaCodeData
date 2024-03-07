using System;
using System.Collections.Generic;
using System.Linq;

public static class Padovan
{
    private static readonly List<int> recurrences = new List<int>();
    private static readonly List<int> floors = new List<int>();
    private const double PP = 1.324717957244746025960908854;
    private const double SS = 1.0453567932525329623;

    public static void Main(string[] args)
    {
        for (int i = 0; i < 64; i++)
        {
            recurrences.Add(PadovanRecurrence(i));
            floors.Add(PadovanFloor(i));
        }

        Console.WriteLine("The first 20 terms of the Padovan sequence:");
        recurrences.GetRange(0, 20).ForEach(term => Console.Write(term + " "));
        Console.WriteLine(Environment.NewLine);

        Console.WriteLine("Recurrence and floor functions agree for first 64 terms? " + recurrences.SequenceEqual(floors));
        Console.WriteLine(Environment.NewLine);

        List<string> words = CreateLSystem();

        Console.WriteLine("The first 10 terms of the L-system:");
        words.GetRange(0, 10).ForEach(term => Console.Write(term + " "));
        Console.WriteLine(Environment.NewLine);

        Console.Write("Length of first 32 terms produced from the L-system match Padovan sequence? ");
        List<int> wordLengths = words.Select(s => s.Length).ToList();
        Console.WriteLine(wordLengths.SequenceEqual(recurrences.GetRange(0, 32)));
    }

    private static int PadovanRecurrence(int n)
    {
        if (n <= 2)
            return 1;
        return recurrences[n - 2] + recurrences[n - 3];
    }

    private static int PadovanFloor(int n)
    {
        return (int)Math.Floor(Math.Pow(PP, n - 1) / SS + 0.5);
    }

    private static List<string> CreateLSystem()
    {
        List<string> words = new List<string>();
        string text = "A";

        while (words.Count < 32)
        {
            words.Add(text);
            char[] textChars = text.ToCharArray();
            text = "";
            foreach (char ch in textChars)
            {
                text += ch switch
                {
                    'A' => "B",
                    'B' => "C",
                    'C' => "AB",
                    _ => throw new InvalidOperationException("Unexpected character found: " + ch),
                };
            }
        }

        return words;
    }
}
