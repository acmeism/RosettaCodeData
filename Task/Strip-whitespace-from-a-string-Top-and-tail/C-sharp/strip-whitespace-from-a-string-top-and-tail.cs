using System;

public class TrimExample
{
    public static void Main(String[] args)
    {
        const string toTrim = " Trim me ";
        Console.WriteLine(Wrap(toTrim.TrimStart()));
        Console.WriteLine(Wrap(toTrim.TrimEnd()));
        Console.WriteLine(Wrap(toTrim.Trim()));
    }

    private static string Wrap(string s)
    {
        return "'" + s + "'";
    }
}
