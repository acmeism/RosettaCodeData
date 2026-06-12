using System;
using System.Collections.Generic;
using System.Linq;

public static class Ngrams
{
    public static void Main(string[] args)
    {
        string text = "Live and let live".ToUpper();
        foreach (int letterCount in new[] { 2, 3, 4 })
        {
            var ngrams = FindNgrams(text, letterCount);
            Console.WriteLine($"All {letterCount}-grams of {text} and their frequencies:");
            foreach (var entry in ngrams)
            {
                Console.WriteLine($"(\"{entry.Key}\" : {entry.Value})");
            }
            Console.WriteLine();
        }
    }

    private static Dictionary<string, int> FindNgrams(string text, int letterCount)
    {
        var ngrams = new Dictionary<string, int>();
        for (int i = 0; i <= text.Length - letterCount; i++)
        {
            string ngram = text.Substring(i, letterCount);
            if (ngrams.ContainsKey(ngram))
            {
                ngrams[ngram]++;
            }
            else
            {
                ngrams[ngram] = 1;
            }
        }
        return Sort(ngrams);
    }

    private static Dictionary<string, int> Sort(Dictionary<string, int> map)
    {
        return map.OrderByDescending(kvp => kvp.Value)
                  .ThenBy(kvp => kvp.Key)
                  .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
    }
}
