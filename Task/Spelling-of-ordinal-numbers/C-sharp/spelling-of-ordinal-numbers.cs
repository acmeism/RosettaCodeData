using System;
using System.Collections.Generic;

class SpellingOfOrdinalNumbers
{
    private static readonly Dictionary<string, string> ordinalMap = new Dictionary<string, string>
    {
        {"one", "first"},
        {"two", "second"},
        {"three", "third"},
        {"five", "fifth"},
        {"eight", "eighth"},
        {"nine", "ninth"},
        {"twelve", "twelfth"}
    };

    static void Main(string[] args)
    {
        long[] tests = new long[] { 1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003L };
        foreach (long test in tests)
        {
            Console.WriteLine($"{test} = {ToOrdinal(test)}");
        }
    }

    private static string ToOrdinal(long n)
    {
        string spelling = NumToString(n);
        string[] split = spelling.Split(' ');
        string last = split[split.Length - 1];
        string replace;
        if (last.Contains("-"))
        {
            string[] lastSplit = last.Split('-');
            string lastWithDash = lastSplit[1];
            string lastReplace;
            if (ordinalMap.ContainsKey(lastWithDash))
            {
                lastReplace = ordinalMap[lastWithDash];
            }
            else if (lastWithDash.EndsWith("y"))
            {
                lastReplace = lastWithDash.Substring(0, lastWithDash.Length - 1) + "ieth";
            }
            else
            {
                lastReplace = lastWithDash + "th";
            }
            replace = lastSplit[0] + "-" + lastReplace;
        }
        else
        {
            if (ordinalMap.ContainsKey(last))
            {
                replace = ordinalMap[last];
            }
            else if (last.EndsWith("y"))
            {
                replace = last.Substring(0, last.Length - 1) + "ieth";
            }
            else
            {
                replace = last + "th";
            }
        }
        split[split.Length - 1] = replace;
        return string.Join(" ", split);
    }

    private static readonly string[] nums = new string[]
    {
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    };

    private static readonly string[] tens = new string[] { "zero", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" };

    private static string NumToString(long n)
    {
        return NumToStringHelper(n);
    }

    private static string NumToStringHelper(long n)
    {
        if (n < 0)
        {
            return "negative " + NumToStringHelper(-n);
        }
        if (n <= 19)
        {
            return nums[n];
        }
        if (n <= 99)
        {
            return tens[n / 10] + (n % 10 > 0 ? "-" + NumToStringHelper(n % 10) : "");
        }
        string label = null;
        long factor = 0;
        if (n <= 999)
        {
            label = "hundred";
            factor = 100;
        }
        else if (n <= 999999)
        {
            label = "thousand";
            factor = 1000;
        }
        else if (n <= 999999999)
        {
            label = "million";
            factor = 1000000;
        }
        else if (n <= 999999999999L)
        {
            label = "billion";
            factor = 1000000000;
        }
        else if (n <= 999999999999999L)
        {
            label = "trillion";
            factor = 1000000000000L;
        }
        else if (n <= 999999999999999999L)
        {
            label = "quadrillion";
            factor = 1000000000000000L;
        }
        else
        {
            label = "quintillion";
            factor = 1000000000000000000L;
        }
        return NumToStringHelper(n / factor) + " " + label + (n % factor > 0 ? " " + NumToStringHelper(n % factor) : "");
    }
}
