using System;
using System.IO;
using System.Linq;
using System.Text;

class Program
{
    static char Rot13(char c)
    {
        if ('a' <= c && c <= 'm' || 'A' <= c && c <= 'M')
        {
            return (char)(c + 13);
        }
        if ('n' <= c && c <= 'z' || 'N' <= c && c <= 'Z')
        {
            return (char)(c - 13);
        }
        return c;
    }

    static string Rot13(string s)
    {
        return new string(s.Select(Rot13).ToArray());
    }


    static void Main(string[] args)
    {
        foreach (var file in args.Where(file => File.Exists(file)))
        {
            Console.WriteLine(Rot13(File.ReadAllText(file)));
        }
        if (!args.Any())
        {
            Console.WriteLine(Rot13(Console.In.ReadToEnd()));
        }
    }
}
