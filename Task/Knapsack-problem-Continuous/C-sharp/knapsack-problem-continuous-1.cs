using System;  //4790@3.6
class Program
{
    static void Main()
    {
        Console.WriteLine(knapSack(15) + "\n");
        var sw = System.Diagnostics.Stopwatch.StartNew();
        for (int i = 1000; i > 0; i--) knapSack(15);
        Console.Write(sw.Elapsed); Console.Read();    // 0.60 µs
    }

    static string knapSack(double w1)
    {
        int k = w.Length; var q = new double[k];
        for (int i = 0; i < k; ) q[i] = v[i] / w[i++];
        var c = new double[k];
        Array.Copy(q, c, k); Array.Sort(c, w);
        Array.Copy(q, c, k); Array.Sort(c, v);
        Array.Sort(q, items);
        string str = "";
        for (k--; k >= 0; k--)
            if (w1 - w[k] > 0) { w1 -= w[k]; str += items[k] + "\n"; }
            else break;
        return w1 > 0 && k >= 0 ? str + items[k] : str;
    }

    static double[] w = { 3.8, 5.4, 3.6, 2.4, 4.0, 2.5, 3.7, 3.0, 5.9 },

                    v = { 36, 43, 90, 45, 30, 56, 67, 95, 98 };

    static string[] items = {"beef","pork","ham","greaves","flitch",
                             "brawn","welt","salami","sausage"};
}
