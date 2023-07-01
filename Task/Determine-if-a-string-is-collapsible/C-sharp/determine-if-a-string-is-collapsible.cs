using System;
using static System.Linq.Enumerable;

public class Program
{
    static void Main()
    {
        string[] input = {
            "",
            "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
            "headmistressship",
            "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
            "..1111111111111111111111111111111111111111111111111111111111111117777888",
            "I never give 'em hell, I just tell the truth, and they think it's hell. ",
            "                                                    --- Harry S Truman  "
        };
        foreach (string s in input) {
            Console.WriteLine($"old: {s.Length} «««{s}»»»");
            string c = Collapse(s);
            Console.WriteLine($"new: {c.Length} «««{c}»»»");
        }
    }

    static string Collapse(string s) => string.IsNullOrEmpty(s) ? "" :
        s[0] + new string(Range(1, s.Length - 1).Where(i => s[i] != s[i - 1]).Select(i => s[i]).ToArray());
}
