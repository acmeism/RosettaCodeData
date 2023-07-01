using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    static void Main()
    {
        foreach (var date in PalindromicDates(2021).Take(15)) WriteLine(date.ToString("yyyy-MM-dd"));
    }

    public static IEnumerable<DateTime> PalindromicDates(int startYear) {
        for (int y = startYear; ; y++) {
            int m = Reverse(y % 100);
            int d = Reverse(y / 100);
            if (IsValidDate(y, m, d, out var date)) yield return date;
        }

        int Reverse(int x) => x % 10 * 10 + x / 10;
        bool IsValidDate(int y, int m, int d, out DateTime date) => DateTime.TryParse($"{y}-{m}-{d}", out date);
    }
}
