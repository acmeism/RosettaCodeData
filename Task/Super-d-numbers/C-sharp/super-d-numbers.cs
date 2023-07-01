using System;
using System.Collections.Generic;
using BI = System.Numerics.BigInteger;
using lbi = System.Collections.Generic.List<System.Numerics.BigInteger[]>;
using static System.Console;

class Program {

    // provides 320 bits (90 decimal digits)
    struct LI { public UInt64 lo, ml, mh, hi, tp; }

    const UInt64 Lm = 1_000_000_000_000_000_000UL;
    const string Fm = "D18";

    static void inc(ref LI d, LI s) { // d += s
        d.lo += s.lo; while (d.lo >= Lm) { d.ml++; d.lo -= Lm; }
        d.ml += s.ml; while (d.ml >= Lm) { d.mh++; d.ml -= Lm; }
        d.mh += s.mh; while (d.mh >= Lm) { d.hi++; d.mh -= Lm; }
        d.hi += s.hi; while (d.hi >= Lm) { d.tp++; d.hi -= Lm; }
        d.tp += s.tp;
    }

    static void set(ref LI d, UInt64 s) { // d = s
        d.lo = s; d.ml = d.mh = d.hi = d.tp = 0;
    }

    const int ls = 10;

    static lbi co = new lbi { new BI[] { 0 } }; // for BigInteger addition
    static List<LI[]> Co = new List<LI[]> { new LI[1] }; // for UInt64 addition

    static Int64 ipow(Int64 bas, Int64 exp) { // Math.Pow()
        Int64 res = 1; while (exp != 0) {
            if ((exp & 1) != 0) res *= bas; exp >>= 1; bas *= bas;
        }
        return res;
    }

    // finishes up, shows performance value
    static void fin() { WriteLine("{0}s", (DateTime.Now - st).TotalSeconds.ToString().Substring(0, 5)); }

    static void funM(int d) { // straightforward BigInteger method, medium performance
        string s = new string(d.ToString()[0], d); Write("{0}: ", d);
        for (int i = 0, c = 0; c < ls; i++)
            if ((BI.Pow((BI)i, d) * d).ToString().Contains(s))
                Write("{0} ", i, ++c);
        fin();
    }

    static void funS(int d) { // BigInteger "mostly adding" method, low performance
        BI[] m = co[d];
        string s = new string(d.ToString()[0], d); Write("{0}: ", d);
        for (int i = 0, c = 0; c < ls; i++) {
            if ((d * m[0]).ToString().Contains(s))
                Write("{0} ", i, ++c);
            for (int j = d, k = d - 1; j > 0; j = k--) m[k] += m[j];
        }
        fin();
    }

    static string scale(uint s, ref LI x) { // performs a small multiply and returns a string value
        ulong Lo = x.lo * s, Ml = x.ml * s, Mh = x.mh * s, Hi = x.hi * s, Tp = x.tp * s;
        while (Lo >= Lm) { Lo -= Lm; Ml++; }
        while (Ml >= Lm) { Ml -= Lm; Mh++; }
        while (Mh >= Lm) { Mh -= Lm; Hi++; }
        while (Hi >= Lm) { Hi -= Lm; Tp++; }
        if (Tp > 0) return Tp.ToString() + Hi.ToString(Fm) + Mh.ToString(Fm) + Ml.ToString(Fm) + Lo.ToString(Fm);
        if (Hi > 0) return Hi.ToString() + Mh.ToString(Fm) + Ml.ToString(Fm) + Lo.ToString(Fm);
        if (Mh > 0) return Mh.ToString() + Ml.ToString(Fm) + Lo.ToString(Fm);
        if (Ml > 0) return Ml.ToString() + Lo.ToString(Fm);
        return Lo.ToString();
    }

    static void funF(int d) { // structure of UInt64 method, high performance
        LI[] m = Co[d];
        string s = new string(d.ToString()[0], d); Write("{0}: ", d);
        for (int i = d, c = 0; c < ls; i++) {
            if (scale((uint)d, ref m[0]).Contains(s))
                Write("{0} ", i, ++c);
            for (int j = d, k = d - 1; j > 0; j = k--)
                inc(ref m[k], m[j]);
        }
        fin();
    }

    static void init() { // initializes co and Co
        for (int v = 1; v < 10; v++) {
            BI[] res = new BI[v + 1];
            long[] f = new long[v + 1], l = new long[v + 1];
            for (int j = 0; j <= v; j++) {
                if (j == v) {
                    LI[] t = new LI[v + 1];
                    for (int y = 0; y <= v; y++) set(ref t[y], (UInt64)f[y]);
                    Co.Add(t);
                }
                res[j] = f[j];
                l[0] = f[0]; f[0] = ipow(j + 1, v);
                for (int a = 0, b = 1; b <= v; a = b++) {
                    l[b] = f[b]; f[b] = f[a] - l[a];
                }
            }
            for (int z = res.Length - 2; z > 0; z -= 2) res[z] *= -1;
            co.Add(res);
        }
    }

    static DateTime st;

    static void doOne(string title, int top, Action<int> func) {
        WriteLine('\n' + title); st = DateTime.Now;
        for (int i = 2; i <= top; i++) func(i);
    }

    static void Main(string[] args)
    {
        init(); const int top = 9;
        doOne("BigInteger mostly addition:", top, funS);
        doOne("BigInteger.Pow():", top, funM);
        doOne("UInt64 structure mostly addition:", top, funF);
    }
}
