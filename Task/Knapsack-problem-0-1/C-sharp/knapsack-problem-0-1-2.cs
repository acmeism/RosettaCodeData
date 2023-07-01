using System
class program
{
    static void Main()
    {
        knapSack(40);
        var sw = System.Diagnostics.Stopwatch.StartNew();
        Console.Write(knapSack(400) + "\n" + sw.Elapsed);  // 31 µs
        Console.Read();
    }

    static string knapSack(uint w1)
    {
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

    static byte[] w =  { 9, 13, 153, 50, 15, 68, 27, 39, 23, 52, 11,
                          32, 24, 48, 73, 42, 43, 22, 7, 18, 4, 30 },

                  v =  { 150, 35, 200, 160, 60, 45, 60, 40, 30, 10, 70,
                          30, 15, 10, 40, 70, 75, 80, 20, 12, 50, 10 };

    static string[] items =  {"map","compass","water","sandwich","glucose","tin",
                              "banana","apple","cheese","beer","suntan cream",
                              "camera","T-shirt","trousers","umbrella",
                              "waterproof trousers","waterproof overclothes",
                              "note-case","sunglasses","towel","socks","book"};
}
