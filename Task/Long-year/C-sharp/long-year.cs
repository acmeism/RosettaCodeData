using static System.Console;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;

public static class Program
{
    public static void Main()
    {
        WriteLine("Long years in the 21st century:");
        WriteLine(string.Join(" ", 2000.To(2100).Where(y => ISOWeek.GetWeeksInYear(y) == 53)));
    }

    public static IEnumerable<int> To(this int start, int end) {
        for (int i = start; i < end; i++) yield return i;
    }

}
