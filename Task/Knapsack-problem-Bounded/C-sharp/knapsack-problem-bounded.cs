using System;  // 4790@3.6
class program
{
    static void Main()
    {
        knapSack(40);
        var sw = System.Diagnostics.Stopwatch.StartNew();
        Console.Write(knapSack(400) + "\n" + sw.Elapsed);  // 51 µs
        Console.Read();
    }

    static string knapSack(uint w1)
    {
        init(); change();
        uint n = (uint)w.Length; var K = new uint[n + 1, w1 + 1];
        for (uint vi, wi, w0, x, i = 0; i < n; i++)
            for (vi = v[i], wi = w[i], w0 = 1; w0 <= w1; w0++)
            {
                x = K[i, w0];
                if (wi <= w0) x = max(vi + K[i, w0 - wi], x);
                K[i + 1, w0] = x;
            }
        string str = "";
        for (uint v1 = K[n, w1]; v1 > 0; n--)
            if (v1 != K[n - 1, w1])
            {
                v1 -= v[n - 1]; w1 -= w[n - 1]; str += items[n - 1] + "\n";
            }
        return str;
    }

    static uint max(uint a, uint b) { return a > b ? a : b; }

    static byte[] w, v; static string[] items;

    static byte[] p = { 1, 1, 2, 2, 2, 3, 3, 3, 1, 3, 1, 1, 2, 2, 1, 1, 1, 1, 1, 2, 1, 2 };

    static void init()
    {
        w = new byte[] { 9, 13, 153, 50, 15, 68, 27, 39, 23, 52, 11,
                          32, 24, 48, 73, 42, 43, 22, 7, 18, 4, 30 };

        v = new byte[] { 150, 35, 200, 60, 60, 45, 60, 40, 30, 10, 70,
                          30, 15, 10, 40, 70, 75, 80, 20, 12, 50, 10 };

        items = new string[] {"map","compass","water","sandwich","glucose","tin",
                              "banana","apple","cheese","beer","suntan cream",
                              "camera","T-shirt","trousers","umbrella",
                              "waterproof trousers","waterproof overclothes",
                              "note-case","sunglasses","towel","socks","book"};
    }

    static void change()
    {
        int n = w.Length, s = 0, i, j, k; byte xi;
        for (i = 0; i < n; i++) s += p[i];
        {
            byte[] x = new byte[s];
            for (k = i = 0; i < n; i++)
                for (xi = w[i], j = p[i]; j > 0; j--) x[k++] = xi;
            w = x;
        }
        {
            byte[] x = new byte[s];
            for (k = i = 0; i < n; i++)
                for (xi = v[i], j = p[i]; j > 0; j--) x[k++] = xi;
            v = x;
        }
        string[] pItems = new string[s]; string itemI;
        for (k = i = 0; i < n; i++)
            for (itemI = items[i], j = p[i]; j > 0; j--) pItems[k++] = itemI;
        items = pItems;
    }
}
