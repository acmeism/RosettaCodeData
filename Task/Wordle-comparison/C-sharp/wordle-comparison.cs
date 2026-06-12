using System;
using System.Collections.Generic;
using System.Linq;

public class WordleComparison
{
    public static void Main(string[] args)
    {
        List<TwoWords> pairs = new List<TwoWords>
        {
            new TwoWords("ALLOW", "LOLLY"),
            new TwoWords("ROBIN", "SONIC"),
            new TwoWords("CHANT", "LATTE"),
            new TwoWords("We're", "She's"),
            new TwoWords("NOMAD", "MAMMA")
        };

        foreach (var pair in pairs)
        {
            Console.WriteLine(pair.Answer + " v " + pair.Guess + " -> " + string.Join(", ", Wordle(pair.Answer, pair.Guess)));
        }
    }

    private static List<Colour> Wordle(string answer, string guess)
    {
        if (answer.Length != guess.Length)
        {
            throw new ArgumentException("The two words must be of the same length.");
        }

        var result = Enumerable.Repeat(Colour.GREY, guess.Length).ToList();
        var answerCopy = answer;

        for (int i = 0; i < guess.Length; i++)
        {
            if (answer[i] == guess[i])
            {
                answerCopy = answerCopy.Remove(i, 1).Insert(i, "\0");
                result[i] = Colour.GREEN;
            }
        }

        for (int i = 0; i < guess.Length; i++)
        {
            int index = answerCopy.IndexOf(guess[i]);
            if (index >= 0 && result[i] != Colour.GREEN)
            {
                answerCopy = answerCopy.Remove(index, 1).Insert(index, "\0");
                result[i] = Colour.YELLOW;
            }
        }

        return result;
    }

    private enum Colour { GREEN, GREY, YELLOW }

    private record TwoWords(string Answer, string Guess);
}
