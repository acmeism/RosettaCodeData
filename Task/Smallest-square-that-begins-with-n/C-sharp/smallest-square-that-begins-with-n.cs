using System;

class Program
{
    static void Main(string[] args)
    {
        int i, d, s, t, n = 50, c = 1;
        var sw = new int[n];
        for (i = d = s = 1; c < n; i++, s += d += 2)
            for (t = s; t > 0; t /= 10)
                if (t < n && sw[t] < 1)
                    Console.Write("", sw[t] = s, c++);
        Console.Write(string.Join(" ", sw).Substring(2));
    }
}
