using System;  // 4790@3.6
using System.Threading.Tasks;
class Program
{
    static void Main()
    {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        Console.Write(knapSack(400) + "\n" + sw.Elapsed);  // 60 ms
        Console.Read();
    }

    static string knapSack(uint w1)
    {
        uint sol = 0, v1 = 0;
        Parallel.For(1, 9, t =>
        {
            uint j, wi, k, vi, i1 = 1u << w.Length;
            for (uint i = (uint)t; i < i1; i += 8)
            {
                k = wi = vi = 0;
                for (j = i; j > 0; j >>= 1, k++)
                    if ((j & 1) > 0)
                    {
                        if ((wi += w[k]) > w1) break;
                        vi += v[k];
                    }
                if (wi <= w1 && v1 < vi)
                    lock (locker)
                        if (v1 < vi) { v1 = vi; sol = i; }
            }
        });
        string str = "";
        for (uint k = 0; sol > 0; sol >>= 1, k++)
            if ((sol & 1) > 0) str += items[k] + "\n";
        return str;
    }

    static readonly object locker = new object();

    static byte[] w = { 9, 13, 153, 50, 15, 68, 27, 39, 23, 52, 11,
                          32, 24, 48, 73, 42, 43, 22, 7, 18, 4, 30 },

                  v = { 150, 35, 200, 160, 60, 45, 60, 40, 30, 10, 70,
                          30, 15, 10, 40, 70, 75, 80, 20, 12, 50, 10 };

    static string[] items = {"map","compass","water","sandwich","glucose","tin",
                             "banana","apple","cheese","beer","suntan cream",
                             "camera","T-shirt","trousers","umbrella",
                             "waterproof trousers","waterproof overclothes",
                             "note-case","sunglasses","towel","socks","book"};
}
