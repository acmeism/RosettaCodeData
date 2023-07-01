using System;
using System.Linq;

static class Program
{
    static bool IsPangram(this string text, string alphabet = "abcdefghijklmnopqrstuvwxyz")
    {
        return alphabet.All(text.ToLower().Contains);
    }

    static void Main(string[] arguments)
    {
        Console.WriteLine(arguments.Any() && arguments.First().IsPangram());
    }
}
