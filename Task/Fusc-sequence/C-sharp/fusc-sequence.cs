using System;
using System.Collections.Generic;

static class program
{
    static int n = 61;
    static List<int> l = new List<int>() { 0, 1 };

    static int fusc(int n)
    {
        if (n < l.Count) return l[n];
        int f = (n & 1) == 0 ? l[n >> 1] : l[(n - 1) >> 1] + l[(n + 1) >> 1];
        l.Add(f); return f;
    }

    static void Main(string[] args)
    {
        bool lst = true; int w = -1, c = 0, t;
        string fs = "{0,11:n0}  {1,-9:n0}", res = "";
        Console.WriteLine("First {0} numbers in the fusc sequence:", n);
        for (int i = 0; i < int.MaxValue; i++)
        {
            int f = fusc(i); if (lst)
            {
                if (i < 61) Console.Write("{0} ", f);
                else
                {
                    lst = false;
                    Console.WriteLine();
                    Console.WriteLine("Points in the sequence where an item has more digits than any previous items:");
                    Console.WriteLine(fs, "Index\\", "/Value"); Console.WriteLine(res); res = "";
                }
            }
            if ((t = f.ToString().Length) > w)
            {
                w = t; res += (res == "" ? "" : "\n") + string.Format(fs, i, f);
                if (!lst) { Console.WriteLine(res); res = ""; } if (++c > 5) break;
            }
        }
        l.Clear();
    }
}
