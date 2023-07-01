using System;

class Program {

    static int l;

    static int[] gp(int n) {
        var c = new bool[n]; var r = new int[(int)(1.28 * n)];
        l = 0; r[l++] = 2; r[l++] = 3; int j, d, lim = (int)Math.Sqrt(n);
        for (int i = 9; i < n; i += 6) c[i] = true;
        for (j = 5, d = 4; j < lim; j += (d = 6 - d)) if (!c[j]) { r[l++] = j;
            for (int k = j * j, ki = j << 1; k < n; k += ki) c[k] = true; }
        for ( ; j < n; j += (d = 6 - d)) if (!c[j]) r[l++] = j; return r; }

    static void Main(string[] args) {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        var res = gp(15485864); sw.Stop();
        double gpt = sw.Elapsed.TotalMilliseconds, tt;
        var s = new string[19]; int si = 0;
        s[si++] = String.Format("primes gen time: {0} ms", gpt); sw.Restart();
        s[si++] = "    Nth Primorial";
        double y = 0; int x = 1, i = 0, lmt = 10;
        s[si++] = String.Format("{0,7} {1}", 0, x);
        while (true) {
            if (i < 9) s[si++] = String.Format("{0,7} {1}", i + 1, x *= res[i]);
            if (i == 8) s[si++] = "    Nth Digits     Time";
            y += Math.Log10(res[i]);
            if (++i == lmt) {
                s[si++] = String.Format("{0,7} {1,-7}  {2,7} ms", lmt, 1 + (int)y,
                    sw.Elapsed.TotalMilliseconds);
                if ((lmt *= 10) > (int)1e6) break;    }    }
        sw.Stop();
        Console.WriteLine("{0}\n     Tabulation: {1} ms", string.Join("\n", s),
            tt = sw.Elapsed.TotalMilliseconds);
        Console.Write("          Total:{0} ms", gpt + tt);    }    }
