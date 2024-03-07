using System;
using System.Globalization;

public class NumberSuffixer
{
    private static readonly string[] Suffixes = { "", "K", "M", "G", "T", "P", "E", "Z", "Y", "X", "W", "V", "U", "googol" };

    public static string Suffize(string num, int? digits = null, int baseNum = 10)
    {
        int exponentDistance = baseNum == 2 ? 10 : 3;
        num = num.Trim().Replace(",", "");
        string numSign = num[0] == '+' || num[0] == '-' ? num.Substring(0, 1) : "";

        num = numSign != "" ? num.Substring(1) : num;
        double number = Math.Abs(double.Parse(num, CultureInfo.InvariantCulture));

        int suffixIndex;
        if (baseNum == 10 && number >= 1e100)
        {
            suffixIndex = 13;
            number /= 1e100;
        }
        else if (number > 1)
        {
            double magnitude = Math.Floor(Math.Log(number, baseNum));
            suffixIndex = Math.Min((int)Math.Floor(magnitude / exponentDistance), 12);
            number /= Math.Pow(baseNum, exponentDistance * suffixIndex);
        }
        else
        {
            suffixIndex = 0;
        }

        string numStr;
        if (digits.HasValue)
        {
            numStr = number.ToString($"F{digits}", CultureInfo.InvariantCulture);
        }
        else
        {
            numStr = number.ToString("F3", CultureInfo.InvariantCulture).TrimEnd('0').TrimEnd('.');
        }

        return numSign + numStr + Suffixes[suffixIndex] + (baseNum == 2 ? "i" : "");
    }

    public static void Main(string[] args)
    {
        var tests = new (string, int?, int?)[]
        {
            ("87,654,321", null, null),
            ("-998,877,665,544,332,211,000", 3, null),
            ("+112,233", 0, null),
            ("16,777,216", 1, null),
            ("456,789,100,000,000", 2, null),
            ("456,789,100,000,000", 2, 10),
            ("456,789,100,000,000", 5, 2),
            ("456,789,100,000.000e+00", 0, 10),
            ("+16777216", null, 2),
            ("1.2e101", null, null),
        };

        foreach (var test in tests)
        {
            Console.WriteLine($"{test.Item1}, {test.Item2?.ToString() ?? "null"}, {test.Item3?.ToString() ?? "null"} : " +
                              $"{Suffize(test.Item1, test.Item2, test.Item3 ?? 10)}");
        }
    }
}
