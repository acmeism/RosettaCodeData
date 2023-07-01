using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class Program
{
    static SortedDictionary<TItem, int> GetFrequencies<TItem>(IEnumerable<TItem> items)
    {
        var dictionary = new SortedDictionary<TItem, int>();
        foreach (var item in items)
        {
            if (dictionary.ContainsKey(item))
            {
                dictionary[item]++;
            }
            else
            {
                dictionary[item] = 1;
            }
        }
        return dictionary;
    }

    static void Main(string[] arguments)
    {
        var file = arguments.FirstOrDefault();
        if (File.Exists(file))
        {
            var text = File.ReadAllText(file);
            foreach (var entry in GetFrequencies(text))
            {
                Console.WriteLine("{0}: {1}", entry.Key, entry.Value);
            }
        }
    }
}
