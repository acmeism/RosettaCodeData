using System;
using System.Text;

public class LevenshteinAlignment
{
    public static string[] Alignment(string a, string b)
    {
        a = a.ToLower();
        b = b.ToLower();

        int[,] costs = new int[a.Length + 1, b.Length + 1];

        for (int j = 0; j <= b.Length; j++)
            costs[0, j] = j;

        for (int i = 1; i <= a.Length; i++)
        {
            costs[i, 0] = i;
            for (int j = 1; j <= b.Length; j++)
            {
                costs[i, j] = Math.Min(1 + Math.Min(costs[i - 1, j], costs[i, j - 1]),
                    a[i - 1] == b[j - 1] ? costs[i - 1, j - 1] : costs[i - 1, j - 1] + 1);
            }
        }

        StringBuilder aPathRev = new StringBuilder();
        StringBuilder bPathRev = new StringBuilder();

        for (int i = a.Length, j = b.Length; i != 0 && j != 0;)
        {
            if (costs[i, j] == (a[i - 1] == b[j - 1] ? costs[i - 1, j - 1] : costs[i - 1, j - 1] + 1))
            {
                aPathRev.Append(a[--i]);
                bPathRev.Append(b[--j]);
            }
            else if (costs[i, j] == 1 + costs[i - 1, j])
            {
                aPathRev.Append(a[--i]);
                bPathRev.Append('-');
            }
            else if (costs[i, j] == 1 + costs[i, j - 1])
            {
                aPathRev.Append('-');
                bPathRev.Append(b[--j]);
            }
        }

        return new string[] { Reverse(aPathRev.ToString()), Reverse(bPathRev.ToString()) };
    }

    private static string Reverse(string s)
    {
        char[] charArray = s.ToCharArray();
        Array.Reverse(charArray);
        return new string(charArray);
    }

    public static void Main(string[] args)
    {
        string[] result = Alignment("rosettacode", "raisethysword");
        Console.WriteLine(result[0]);
        Console.WriteLine(result[1]);
    }
}
