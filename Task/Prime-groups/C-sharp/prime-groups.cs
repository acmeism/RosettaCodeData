using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    private static bool IsPrime(int n)
    {
        if (n <= 1) return false;
        for (int i = 2; i * i <= n; i++)
            if (n % i == 0)
                return false;
        return true;
    }

    private static bool AllDiffsPrime(char[] chars)
    {
        for (int i = 0; i < chars.Length; i++)
            for (int j = i + 1; j < chars.Length; j++)
                if (!IsPrime(Math.Abs(chars[i] - chars[j])))
                    return false;
        return true;
    }

    private static IEnumerable<T[]> Subsets<T>(T[] arr, int k)
    {
        if (k <= 0) yield break;
        int[] a = Enumerable.Range(0, k).ToArray();
        int n = arr.Length;
        while (true) {
            yield return a.Select(i => arr[i]).ToArray();
            if (a[0] == n - k) break;
            int i = k - 1;
            while (a[i] == n - k + i) i--;
            a[i]++;
            for (int j = i + 1; j < k; j++) a[j] = a[j - 1] + 1;
        }
    }

    private static string FirstPrimeGroup(string s, int k)
    {
        foreach (var subset in Subsets<char>(s.ToCharArray(), k))
            if (AllDiffsPrime(subset))
                return new string(subset);
        return "Not found.";
    }

    static void Main()
    {
        string[] testCases = ["riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja"];

        foreach (var testCase in testCases)
            Console.WriteLine(FirstPrimeGroup(testCase, 3));

        Console.WriteLine();

        foreach (var testCase in testCases)
            Console.WriteLine(FirstPrimeGroup(testCase, 2));
    }
}
