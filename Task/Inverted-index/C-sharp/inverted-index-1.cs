using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class InvertedIndex
{
    static Dictionary<TItem, IEnumerable<TKey>> Invert<TKey, TItem>(Dictionary<TKey, IEnumerable<TItem>> dictionary)
    {
        return dictionary
            .SelectMany(keyValuePair => keyValuePair.Value.Select(item => new KeyValuePair<TItem, TKey>(item, keyValuePair.Key)))
            .GroupBy(keyValuePair => keyValuePair.Key)
            .ToDictionary(group => group.Key, group => group.Select(keyValuePair => keyValuePair.Value));
    }

    static void Main()
    {
        Console.Write("files: ");
        var files = Console.ReadLine();
        Console.Write("find: ");
        var find = Console.ReadLine();
        var dictionary = files.Split().ToDictionary(file => file, file => File.ReadAllText(file).Split().AsEnumerable());
        Console.WriteLine("{0} found in: {1}", find, string.Join(" ", Invert(dictionary)[find]));
    }
}
