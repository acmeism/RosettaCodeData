using System;
using System.Collections.Generic;
using System.Globalization;
using System.Numerics;
using System.Text;

public class NextHighestIntFromDigits
{
    public static void Main(string[] args)
    {
        foreach (var s in new string[] { "0", "9", "12", "21", "12453", "738440", "45072010", "95322020", "9589776899767587796600", "3345333" })
        {
            Console.WriteLine($"{Format(s)} -> {Format(Next(s))}");
        }
        TestAll("12345");
        TestAll("11122");
    }

    private static string Format(string s)
    {
        return BigInteger.Parse(s).ToString("N0", CultureInfo.InvariantCulture);
    }

    private static void TestAll(string s)
    {
        Console.WriteLine($"Test all permutations of:  {s}");
        var sOrig = s;
        var sPrev = s;
        int count = 1;

        // Check permutation order. Each is greater than the last
        bool orderOk = true;
        var uniqueMap = new Dictionary<string, int>();
        uniqueMap[s] = 1;
        while ((s = Next(s)) != "0")
        {
            count++;
            if (BigInteger.Parse(s) < BigInteger.Parse(sPrev))
            {
                orderOk = false;
            }
            if (uniqueMap.ContainsKey(s))
            {
                uniqueMap[s]++;
            }
            else
            {
                uniqueMap[s] = 1;
            }
            sPrev = s;
        }
        Console.WriteLine($"    Order:  OK =  {orderOk}");

        // Test last permutation
        var reverse = Reverse(sOrig);
        Console.WriteLine($"    Last permutation:  Actual = {sPrev}, Expected = {reverse}, OK = {sPrev == reverse}");

        // Check permutations unique
        bool unique = true;
        foreach (var key in uniqueMap.Keys)
        {
            if (uniqueMap[key] > 1)
            {
                unique = false;
            }
        }
        Console.WriteLine($"    Permutations unique:  OK =  {unique}");

        // Check expected count.
        var charMap = new Dictionary<char, int>();
        foreach (var c in sOrig)
        {
            if (charMap.ContainsKey(c))
            {
                charMap[c]++;
            }
            else
            {
                charMap[c] = 1;
            }
        }
        BigInteger permCount = Factorial(sOrig.Length);
        foreach (var c in charMap.Keys)
        {
            permCount /= Factorial(charMap[c]);
        }
        Console.WriteLine($"    Permutation count:  Actual = {count}, Expected = {permCount}, OK = {count == permCount}");
    }

    private static BigInteger Factorial(int n)
    {
        BigInteger fact = 1;
        for (int num = 2; num <= n; num++)
        {
            fact *= num;
        }
        return fact;
    }

    private static string Next(string s)
    {
        var sb = new StringBuilder();
        int index = s.Length - 1;
        // Scan right-to-left through the digits of the number until you find a digit with a larger digit somewhere to the right of it.
        while (index > 0 && s[index - 1] >= s[index])
        {
            index--;
        }
        // Reached beginning. No next number.
        if (index == 0)
        {
            return "0";
        }

        // Find digit on the right that is both more than it, and closest to it.
        int index2 = index;
        for (int i = index + 1; i < s.Length; i++)
        {
            if (s[i] < s[index2] && s[i] > s[index - 1])
            {
                index2 = i;
            }
        }

        // Found data, now build string
        // Beginning of String
        if (index > 1)
        {
            sb.Append(s.Substring(0, index - 1));
        }

        // Append found, place next
        sb.Append(s[index2]);

        // Get remaining characters
        List<char> chars = new List<char>();
        chars.Add(s[index - 1]);
        for (int i = index; i < s.Length; i++)
        {
            if (i != index2)
            {
                chars.Add(s[i]);
            }
        }

        // Order the digits to the right of this position, after the swap; lowest-to-highest, left-to-right.
        chars.Sort();
        foreach (var c in chars)
        {
            sb.Append(c);
        }
        return sb.ToString();
    }

    private static string Reverse(string s)
    {
        var charArray = s.ToCharArray();
        Array.Reverse(charArray);
        return new string(charArray);
    }
}
