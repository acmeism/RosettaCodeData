using System;

class Program {

    static uint[] res = new uint[10];
    static uint ri = 1, p = 10, count = 0;

    static void TabulateTwinPrimes(uint bound) {
        if (bound < 5) return; count++;
        uint cl = (bound - 1) >> 1, i = 1, j,
             limit = (uint)(Math.Sqrt(bound) - 1) >> 1;
        var comp = new bool[cl]; bool lp;
        for (j = 3; j < cl; j += 3) comp[j] = true;
        while (i < limit) {
            if (lp = !comp[i]) {
                uint pr = (i << 1) + 3;
                for (j = (pr * pr - 2) >> 1; j < cl; j += pr)
                    comp[j] = true;
            }
            if (!comp[++i]) {
                uint pr = (i << 1) + 3;
                if (lp) {
                    if (pr > p) {
                        res[ri++] = count;
                        p *= 10;
                    }
                    count++;
                    i++;
                }
                for (j = (pr * pr - 2) >> 1; j < cl; j += pr)
                    comp[j] = true;
            }
        }
        cl--;
        while (i < cl) {
            lp = !comp[i++];
            if (!comp[i] && lp) {
                if ((i++ << 1) + 3 > p) {
                    res[ri++] = count;
                    p *= 10;
                }
                count++;
            }
        }
        res[ri] = count;
    }

    static void Main(string[] args) {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        string fmt = "{0,9:n0} twin primes below {1,-13:n0}";
        TabulateTwinPrimes(1_000_000_000);
        sw.Stop();
        p = 1;
        for (var j = 1; j <= ri; j++)
            Console.WriteLine(fmt, res[j], p *= 10);
        Console.Write("{0} sec", sw.Elapsed.TotalSeconds);
    }
}
