using System;
using System.Collections.Generic;
using System.Text;

public class SequenceGenerator
{
    public static void Main(string[] args)
    {
        string result = GenerateSequence(5, 13);
        Console.WriteLine(result); // Should print 1001010010100
    }

    public static string GenerateSequence(int k, int n)
    {
        List<List<int>> s = new List<List<int>>();

        for (int i = 0; i < n; i++)
        {
            List<int> innerList = new List<int>();
            if (i < k)
            {
                innerList.Add(1);
            }
            else
            {
                innerList.Add(0);
            }
            s.Add(innerList);
        }

        int d = n - k;
        n = Math.Max(k, d);
        k = Math.Min(k, d);
        int z = d;

        while (z > 0 || k > 1)
        {
            for (int i = 0; i < k; i++)
            {
                s[i].AddRange(s[s.Count - 1 - i]);
            }
            s = s.GetRange(0, s.Count - k);
            z -= k;
            d = n - k;
            n = Math.Max(k, d);
            k = Math.Min(k, d);
        }

        StringBuilder result = new StringBuilder();
        foreach (List<int> sublist in s)
        {
            foreach (int item in sublist)
            {
                result.Append(item);
            }
        }
        return result.ToString();
    }
}
