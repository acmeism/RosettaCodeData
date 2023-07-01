using System;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.IO;

public class Semordnilap
{
    public static void Main() {
        var results = FindSemordnilaps("http://www.puzzlers.org/pub/wordlists/unixdict.txt").ToList();
        Console.WriteLine(results.Count);
        var random = new Random();
        Console.WriteLine("5 random results:");
        foreach (string s in results.OrderBy(_ => random.Next()).Distinct().Take(5)) Console.WriteLine(s + " " + Reversed(s));
    }

    private static IEnumerable<string> FindSemordnilaps(string url) {
        var found = new HashSet<string>();
        foreach (string line in GetLines(url)) {
            string reversed = Reversed(line);
            //Not taking advantage of the fact the input file is sorted
            if (line.CompareTo(reversed) != 0) {
                if (found.Remove(reversed)) yield return reversed;
                else found.Add(line);
            }
        }
    }

    private static IEnumerable<string> GetLines(string url) {
        WebRequest request = WebRequest.Create(url);
        using (var reader = new StreamReader(request.GetResponse().GetResponseStream(), true)) {
            while (!reader.EndOfStream) {
                yield return reader.ReadLine();
            }
        }
    }

    private static string Reversed(string value) => new string(value.Reverse().ToArray());
}
