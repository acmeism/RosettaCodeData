using System;
using System.Globalization;

public class Program
{
    public static void Main() => WriteLine(DateDiff("1970-01-01", "2019-10-18"));

    public static int DateDiff(string d1, string d2) {
        var a = DateTime.ParseExact(d1, "yyyy-MM-dd", CultureInfo.InvariantCulture);
        var b = DateTime.ParseExact(d2, "yyyy-MM-dd", CultureInfo.InvariantCulture);
        return (int)(b - a).TotalDays;
    }
}
