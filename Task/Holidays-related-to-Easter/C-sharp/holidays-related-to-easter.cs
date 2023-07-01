using System;
using System.Collections;
using System.Collections.Specialized;
using System.Linq;

internal class Program
{
    private static readonly OrderedDictionary _holidayOffsets = new OrderedDictionary
                                                                    {
                                                                        {"Easter", 0},
                                                                        {"Ascension", 39},
                                                                        {"Pentecost", 49},
                                                                        {"Trinity", 56},
                                                                        {"Corpus", 60},
                                                                    };

    static void Main(string[] args)
    {
        Console.WriteLine("Christian holidays, related to Easter, for each centennial from 400 to 2100 CE:");
        for (int year = 400; year <= 2100; year += 100)
            OutputHolidays(year);

        Console.WriteLine();
        Console.WriteLine("Christian holidays, related to Easter, for years from 2010 to 2020 CE:");
        for (int year = 2010; year <= 2020; year += 1)
            OutputHolidays(year);
    }

    static void OutputHolidays(int year)
    {
        var easter = CalculateEaster(year);
        var holidays = from kp in _holidayOffsets.OfType<DictionaryEntry>()
                       let holiday = easter.AddDays(Convert.ToInt32(kp.Value))
                       select kp.Key + ": " + string.Format("{0,2:ddd} {0,2:%d} {0:MMM}", holiday);
        Console.WriteLine("{0,4} {1}", year, string.Join(", ", holidays.ToArray()));
    }

    static DateTime CalculateEaster(int year)
    {
        var a = year % 19;
        var b = year / 100;
        var c = year %100;
        var d = b / 4;
        var e = b % 4;
        var f = (b + 8) / 25;
        var g = (b - f + 1) / 3;
        var h = (19 * a + b - d - g + 15) % 30;
        var i = c / 4;
        var k = c % 4;
        var l = (32 + 2 * e + 2 * i - h - k) % 7;
        var m = (a + 11 * h + 22 * l) / 451;
        var numerator = h + l - 7 * m + 114;
        var month = numerator / 31;
        var day = (numerator % 31) + 1;
        return new DateTime(year, month, day);
    }
}
