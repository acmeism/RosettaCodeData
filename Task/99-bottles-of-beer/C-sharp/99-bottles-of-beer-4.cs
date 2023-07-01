using System;
using System.Globalization;
class Program
{
    const string Vessel = "bottle";
    const string Beverage = "beer";
    const string Location = "on the wall";

    private static string DefaultAction(ref int bottles)
    {
        bottles--;
        return "take one down, pass it around,";
    }

    private static string FallbackAction(ref int bottles)
    {
        bottles += 99;
        return "go to the store, buy some more,";
    }

    private static string Act(ref int bottles)
    {
        return bottles > 0 ? DefaultAction(ref bottles) : FallbackAction(ref bottles);
    }

    static void Main()
    {
        Func<int, string> plural = b => b == 1 ? "" : "s";
        Func<int, string> describeCount = b => b == 0 ? "no more" : b.ToString();
        Func<int, string> describeBottles = b => string.Format("{0} {1}{2} of {3}", describeCount(b), Vessel, plural(b), Beverage);
        Action<string> write = s => Console.WriteLine(CultureInfo.CurrentCulture.TextInfo.ToTitleCase(s));
        int bottles = 99;
        while (true)
        {
            write(string.Format("{0} {1}, {0},", describeBottles(bottles), Location));
            write(Act(ref bottles));
            write(string.Format("{0} {1}.", describeBottles(bottles), Location));
            write(string.Empty);
        }
    }
}
