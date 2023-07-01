using System;
using System.Collections.Generic;
using System.Linq;
using static System.Console;
using UI = System.UInt64;
using LST = System.Collections.Generic.List<System.Collections.Generic.List<sbyte>>;
using Lst = System.Collections.Generic.List<sbyte>;
using DT = System.DateTime;

class Program {

    const sbyte MxD = 19;

    public struct term { public UI coeff; public sbyte a, b;
        public term(UI c, int a_, int b_) { coeff = c; a = (sbyte)a_; b = (sbyte)b_; } }

    static int[] digs;   static List<UI> res;   static sbyte count = 0;
    static DT st; static List<List<term>> tLst; static List<LST> lists;
    static Dictionary<int, LST> fml, dmd; static Lst dl, zl, el, ol, il;
    static bool odd; static int nd, nd2; static LST ixs;
    static int[] cnd, di; static LST dis; static UI Dif;

    // converts digs array to the "difference"
    static UI ToDif() { UI r = 0; for (int i = 0; i < digs.Length; i++)
            r = r * 10 + (uint)digs[i]; return r; }

    // converts digs array to the "sum"
    static UI ToSum() { UI r = 0; for (int i = digs.Length - 1; i >= 0; i--)
            r = r * 10 + (uint)digs[i]; return Dif + (r << 1); }

    // determines if the nmbr is square or not
    static bool IsSquare(UI nmbr) { if ((0x202021202030213 & (1 << (int)(nmbr & 63))) != 0)
        { UI r = (UI)Math.Sqrt((double)nmbr); return r * r == nmbr; } return false; }

    // returns sequence of sbytes
    static Lst Seq(sbyte from, int to, sbyte stp = 1) { Lst res = new Lst();
        for (sbyte item = from; item <= to; item += stp) res.Add(item); return res; }

    // Recursive closure to generate (n+r) candidates from (n-r) candidates
    static void Fnpr(int lev) { if (lev == dis.Count) { digs[ixs[0][0]] = fml[cnd[0]][di[0]][0];
            digs[ixs[0][1]] = fml[cnd[0]][di[0]][1]; int le = di.Length, i = 1;
            if (odd) digs[nd >> 1] = di[--le]; foreach (sbyte d in di.Skip(1).Take(le - 1)) {
                digs[ixs[i][0]] = dmd[cnd[i]][d][0]; digs[ixs[i][1]] = dmd[cnd[i++]][d][1]; }
            if (!IsSquare(ToSum())) return; res.Add(ToDif()); WriteLine("{0,16:n0}{1,4}   ({2:n0})",
                (DT.Now - st).TotalMilliseconds, ++count, res.Last()); }
        else foreach (var n in dis[lev]) { di[lev] = n; Fnpr(lev + 1); } }

    // Recursive closure to generate (n-r) candidates with a given number of digits.
    static void Fnmr (LST list, int lev) { if (lev == list.Count) { Dif = 0; sbyte i = 0;
            foreach (var t in tLst[nd2]) { if (cnd[i] < 0) Dif -= t.coeff * (UI)(-cnd[i++]);
                else Dif += t.coeff * (UI)cnd[i++]; } if (Dif <= 0 || !IsSquare(Dif)) return;
            dis = new LST { Seq(0, fml[cnd[0]].Count - 1) };
            foreach (int ii in cnd.Skip(1)) dis.Add(Seq(0, dmd[ii].Count - 1));
            if (odd) dis.Add(il); di = new int[dis.Count]; Fnpr(0);
        } else foreach(sbyte n in list[lev]) { cnd[lev] = n; Fnmr(list, lev + 1); } }

    static void init() { UI pow = 1;
        // terms of (n-r) expression for number of digits from 2 to maxDigits
        tLst = new List<List<term>>(); foreach (int r in Seq(2, MxD)) {
            List<term> terms = new List<term>(); pow *= 10; UI p1 = pow, p2 = 1;
            for (int i1 = 0, i2 = r - 1; i1 < i2; i1++, i2--) {
                terms.Add(new term(p1 - p2, i1, i2)); p1 /= 10; p2 *= 10; }
            tLst.Add(terms); }
        //  map of first minus last digits for 'n' to pairs giving this value
        fml = new Dictionary<int, LST> {
            [0] = new LST { new Lst { 2, 2 }, new Lst { 8, 8 } },
            [1] = new LST { new Lst { 6, 5 }, new Lst { 8, 7 } },
            [4] = new LST { new Lst { 4, 0 } },
            [6] = new LST { new Lst { 6, 0 }, new Lst { 8, 2 } } };
        // map of other digit differences for 'n' to pairs giving this value
        dmd = new Dictionary<int, LST>();
        for (sbyte i = 0; i < 10; i++) for (sbyte j = 0, d = i; j < 10; j++, d--) {
                if (dmd.ContainsKey(d)) dmd[d].Add(new Lst { i, j });
                else dmd[d] = new LST { new Lst { i, j } }; }
        dl = Seq(-9, 9);    // all differences
        zl = Seq( 0, 0);    // zero differences only
        el = Seq(-8, 8, 2); // even differences only
        ol = Seq(-9, 9, 2); // odd differences only
        il = Seq( 0, 9); lists = new List<LST>();
        foreach (sbyte f in fml.Keys) lists.Add(new LST { new Lst { f } }); }

    static void Main(string[] args) { init(); res = new List<UI>(); st = DT.Now; count = 0;
        WriteLine("{0,5}{1,12}{2,4}{3,14}", "digs", "elapsed(ms)", "R/N", "Unordered Rare Numbers");
        for (nd = 2, nd2 = 0, odd = false; nd <= MxD; nd++, nd2++, odd = !odd) { digs = new int[nd];
            if (nd == 4) { lists[0].Add(zl); lists[1].Add(ol); lists[2].Add(el); lists[3].Add(ol); }
            else if (tLst[nd2].Count > lists[0].Count) foreach (LST list in lists) list.Add(dl);
            ixs = new LST();
            foreach (term t in tLst[nd2]) ixs.Add(new Lst { t.a, t.b });
            foreach (LST list in lists) { cnd = new int[list.Count]; Fnmr(list, 0); }
            WriteLine("  {0,2}  {1,10:n0}", nd, (DT.Now - st).TotalMilliseconds); }
        res.Sort();
        WriteLine("\nThe {0} rare numbers with up to {1} digits are:", res.Count, MxD);
        count = 0; foreach (var rare in res) WriteLine("{0,2}:{1,27:n0}", ++count, rare);
        if (System.Diagnostics.Debugger.IsAttached) ReadKey(); }
}
