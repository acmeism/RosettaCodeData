using System;
using System.Text.RegularExpressions;

public class Program
{
    private delegate void fOk(bool ok, string message);

    public static int Main(string[] args)
    {
        const string raw = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";
        const string code = "12W1B12W3B24W1B14W";

        fOk Ok = delegate(bool ok, string message)
        {
            Console.WriteLine("{0}: {1}", ok ? "ok" : "not ok", message);
        };
        Ok(code.Equals(Encode(raw)), "Encode");
        Ok(raw.Equals(Decode(code)), "Decode");
        return 0;
    }

    public static string Encode(string input)
    {
        return Regex.Replace(input, @"(.)\1*", delegate(Match m)
        {
            return string.Concat(m.Value.Length, m.Groups[1].Value);
        });
    }

    public static string Decode(string input)
    {
        return Regex.Replace(input, @"(\d+)(\D)", delegate(Match m)
        {
            return new string(m.Groups[2].Value[0], int.Parse(m.Groups[1].Value));
        });
    }
}
