using System;
using static System.Linq.Enumerable;

public class Program
{
    static void Main()
    {
        SqueezeAndPrint("", ' ');
        SqueezeAndPrint("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ", '-');
        SqueezeAndPrint("..1111111111111111111111111111111111111111111111111111111111111117777888", '7');
        SqueezeAndPrint("I never give 'em hell, I just tell the truth, and they think it's hell. ", '.');
        string s = "                                                    --- Harry S Truman  ";
        SqueezeAndPrint(s, ' ');
        SqueezeAndPrint(s, '-');
        SqueezeAndPrint(s, 'r');
    }

    static void SqueezeAndPrint(string s, char c) {
        Console.WriteLine($"squeeze: '{c}'");
        Console.WriteLine($"old: {s.Length} «««{s}»»»");
        s = Squeeze(s, c);
        Console.WriteLine($"new: {s.Length} «««{s}»»»");
    }

    static string Squeeze(string s, char c) => string.IsNullOrEmpty(s) ? "" :
        s[0] + new string(Range(1, s.Length - 1).Where(i => s[i] != c || s[i] != s[i - 1]).Select(i => s[i]).ToArray());
}
