using System;
class Program
{
    static void Main()
    {
        Console.WriteLine(knapSack(15) + "\n");
        var sw = System.Diagnostics.Stopwatch.StartNew();
        for (int i = 1000; i > 0; i--) knapSack(15);
        Console.Write(sw.Elapsed); Console.Read();    // 0.37 µs
    }

    static string knapSack(double w1)
    {
        int i = 0, k = w.Length; var idx = new int[k];
        {
            var q = new double[k];
            while (i < k) q[i] = v[i] / w[idx[i] = i++];
            Array.Sort(q, idx);
        }
        string str = "";
        for (k--; k >= 0; k--)
            if (w1 > w[i = idx[k]]) { w1 -= w[i]; str += items[i] + "\n"; }
            else break;
        return w1 > 0 && k >= 0 ? str + items[idx[k]] : str;
    }

    static double[] w = { 3.8, 5.4, 3.6, 2.4, 4.0, 2.5, 3.7, 3.0, 5.9 },

                    v = { 36, 43, 90, 45, 30, 56, 67, 95, 98 };

    static string[] items = {"beef","pork","ham","greaves","flitch",
                             "brawn","welt","salami","sausage"};
}
