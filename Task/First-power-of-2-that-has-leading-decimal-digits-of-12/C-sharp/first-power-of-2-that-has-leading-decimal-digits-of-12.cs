// a mini chrestomathy solution

using System;

class Program {

    // translated from java example
    static long js(int l, int n) {
        long res = 0, f = 1;
        double lf = Math.Log10(2);
        for (int i = l; i > 10; i /= 10) f *= 10;
        while (n > 0)
            if ((int)(f * Math.Pow(10, ++res * lf % 1)) == l) n--;
        return res;
    }

    // translated from go integer example (a.k.a. go translation of pascal alternative example)
    static long gi(int ld, int n) {
        string Ls = ld.ToString();
        long res = 0, count = 0, f = 1;
        for (int i = 1; i <= 18 - Ls.Length; i++) f *= 10;
        const long ten18 = (long)1e18; long probe = 1;
        do {
            probe <<= 1; res++; if (probe >= ten18)
                do {
                    if (probe >= ten18) probe /= 10;
                    if (probe / f == ld)
                        if (++count >= n) { count--; break; }
                    probe <<= 1; res++;
                } while (true);
            string ps = probe.ToString();
            if (ps.Substring(0, Math.Min(Ls.Length, ps.Length)) == Ls)
                if (++count >= n) break;
        } while (true);
        return res;
    }

    // translated from pascal alternative example
    static long pa(int ld, int n) {
        double L_float64 = Math.Pow(2, 64);
        ulong Log10_2_64 = (ulong)(L_float64 * Math.Log10(2));
        double Log10Num; ulong LmtUpper, LmtLower, Frac64;
        long res = 0, dgts = 1, cnt;
        for (int i = ld; i >= 10; i /= 10) dgts *= 10;
        Log10Num = Math.Log10((ld + 1.0) / dgts);
        // '316' was a limit
        if (Log10Num >= 0.5) {
            LmtUpper = (ld + 1.0) / dgts < 10.0 ? (ulong)(Log10Num * (L_float64 * 0.5)) * 2 + (ulong)(Log10Num * 2) : 0;
            Log10Num = Math.Log10((double)ld / dgts);
            LmtLower = (ulong)(Log10Num * (L_float64 * 0.5)) * 2 + (ulong)(Log10Num * 2);
        } else {
            LmtUpper = (ulong)(Log10Num * L_float64);
            LmtLower = (ulong)(Math.Log10((double)ld / dgts) * L_float64);
        }
        cnt = 0; Frac64 = 0; if (LmtUpper != 0)
            do {
                res++; Frac64 += Log10_2_64;
                if ((Frac64 >= LmtLower) & (Frac64 < LmtUpper))
                    if (++cnt >= n) break;
            } while (true);
        else // '999..'
            do {
                res++; Frac64 += Log10_2_64;
                if (Frac64 >= LmtLower) if (++cnt >= n) break;
            } while (true);
        return res;
    }

    static int[] values = new int[] { 12, 1, 12, 2, 123, 45, 123, 12345, 123, 678910, 99, 1 };

    static void doOne(string name, Func<int, int, long> fun) {
        Console.WriteLine("{0} version:", name);
        var start = DateTime.Now;
        for (int i = 0; i < values.Length; i += 2)
            Console.WriteLine("p({0,3}, {1,6}) = {2,11:n0}", values[i], values[i + 1], fun(values[i], values[i + 1]));
        Console.WriteLine("Took {0} seconds\n", DateTime.Now - start);
    }

    static void Main() {
        doOne("java simple", js);
        doOne("go integer", gi);
        doOne("pascal alternative", pa);
    }
}
