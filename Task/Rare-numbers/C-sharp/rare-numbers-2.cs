using static System.Math;          // for Sqrt()
using System.Collections.Generic;  // for List<>, .Count
using System.Linq;                 // for .Last(), .ToList()
using System.Diagnostics;          // for Stopwatch()
using static System.Console;       // for Write(), WriteLine()
using llst = System.Collections.Generic.List<int[]>;
class Program
{
    #region vars
    static int[] d,     // permutation working array
        drar = new int[19], // digital root lookup array
        dac;            // running digital root array
    static long[] p = new long[20],  // powers of 10
        ac,             // accumulator array
        pp;             // long coefficient array that combines with digits of working array
    static bool odd = false;  // flag for odd number of digits
    static long sum,    // calculated sum of terms (square candidate)
        rt;             // root of sum
    static int cn = 0,  // solution counter
        nd = 2,         // number of digits
        nd1 = nd - 1,   // nd helper
        ln,             // previous value of "n" (in Recurse())
        dl;             // length of "d" array;
    static Stopwatch sw = new Stopwatch(), swt = new Stopwatch();  // for timings
    static List<long> sr = new List<long>();  // temporary list of squares used for building
    static readonly int[] tlo = new int[] { 0, 1, 4, 5, 6 },  // primary differences starting point
        all = Seq(-9, 9),     // all possible differences
        odl = Seq(-9, 9, 2),  // odd possible differences
        evl = Seq(-8, 8, 2),  // even possible differences
        thi = new int[] { 4, 5, 6, 9, 10, 11, 14, 15, 16 }, // primary sums staring point. note: (0, 1) omitted, as any square generated will not have enough digits
        alh = Seq(0, 18),     // all possible sums
        odh = Seq(1, 17, 2),  // odd possible sums
        evh = Seq(0, 18, 2),  // even possible sums
        ten = Seq(0, 9),      // used for odd number of digits
        z = Seq(0, 0),        // no difference, used to avoid generating a bunch of negative square candidates
        t7 = new int[] { -3, 7 },   // shortcut for low 5
        nin = new int[] { 9 },      // shortcut for hi 10
        tn = new int[] { 10 },      // shortcut for hi 0 (unused, uneeded)
        t12 = new int[] { 2, 12 },  // shortcut for hi 5
        o11 = new int[] { 1, 11 },  // shortcut for hi 15
        pos = new int[] { 0, 1, 4, 5, 6, 9 }; // shortcut for 2nd lo 0
    static llst lul = new llst { z, odl, null, null, evl, t7, odl },  // shortcut lookup lo primary
      luh = new llst { tn, evh, null, null, evh, t12, odh, null, null, evh, nin, odh, null, null, odh, o11, evh },  // shortcut lookup hi primary
      l2l = new llst { pos, null, null, null, all, null, all },     // shortcut lookup lo secondary
      l2h = new llst { null, null, null, null, alh, null, alh, null, null, null, alh, null, null, null, alh, null, alh }, lu, l2;  // shortcut lookup hi secondary
    static int[][] chTen = new int[][] { new int[] { 0,2,5,8,9 }, new int[] { 0,3,4,6,9 }, new int[] { 1,4,7,8 },   new int[] { 2,3,5,8 },
                new int[] { 0,3,6,7,9 }, new int[] { 1,2,4,7 },   new int[] { 2,5,6,8 },   new int[] { 0,1,3,6,9 }, new int[] { 1,4,5,7 } };
    static int[][] chAH = new int[][] {  new int[] { 0,2,5,8,9,11,14,17,18 }, new int[] { 0,3,4,6,9,12,13,15,18 },  new int[] { 1,4,7,8,10,13,16,17 },
                                         new int[] { 2,3,5,8,11,12,14,17 },   new int[] { 0,3,6,7,9,12,15,16,18 },  new int[] { 1,2,4,7,10,11,13,16 },
                                         new int[] { 2,5,6,8,11,14,15,17 },   new int[] { 0,1,3,6,9,10,12,15,18 },  new int[] { 1,4,5,7,10,13,14,16 } };
    #endregion vars

    // Returns a sequence of integers
    static int[] Seq(int f, int t, int s = 1) { int[] r = new int[(t - f) / s + 1]; for (int i = 0; i < r.Length; i++, f += s) r[i] = f; return r; }

    // Returns Integer Square Root
    static long ISR(long s) { return (long)Sqrt(s); }

    // Recursively determines whether "r" is the reverse of "f"
    static bool IsRev(int nd, long f, long r) { nd--; return f / p[nd] != r % 10 ? false : (nd < 1 ? true : IsRev(nd, f % p[nd], r / 10)); }

    // Recursive procedure to evaluate the permutations, no shortcuts
    static void RecurseLE5(llst lst, int lv) { if (lv == dl) {  // check if on last stage of permutation
            if ((sum = ac[lv - 1]) > 0) if ((rt = (long)Sqrt(sum)) * rt == sum) sr.Add(sum); }  // test accumulated sum, append to result if square
        else foreach (int n in lst[lv]) {       // set up next permutation
                d[lv] = n; if (lv == 0) ac[0] = pp[0] * n; else ac[lv] = ac[lv - 1] + pp[lv] * n; // update accumulated sum
                RecurseLE5(lst, lv + 1); } }    // Recursively call next level

    // Recursive procedure to evaluate the hi permutations, shortcuts added to avoid generating many non-squares, digital root calc added
    static void Recursehi(llst lst, int lv) {
        int lv1 = lv - 1; if (lv == dl) {  // check if on last stage of permutation
        if ((0x202021202030213 & (1 << (int)((sum = ac[lv1]) & 63))) != 0)  // test accumulated sum, append to result if square
                if ((rt = (long)Sqrt(sum)) * rt == sum) sr.Add(sum); }
        else foreach (int n in lst[lv]) {  // set up next permutation
                d[lv] = n; if (lv == 0) { ac[0] = pp[0] * n; dac[0] = drar[n]; }  // update accumulated sum and running dr
                else { ac[lv] = ac[lv1] + pp[lv] * n; dac[lv] = dac[lv1] + drar[n]; if (dac[lv] > 8) dac[lv] -= 9; }
                switch (lv) {                                            // shortcuts to be performed on designated levels
                    case 0: lst[1] = lu[ln = n]; lst[2] = l2[n]; break;  // primary level: set shortcuts for secondary level
                    case 1:                                              // secondary level: set shortcuts for tertiary level
                        switch (ln) {  // for sums
                            case 5: case 15: lst[2] = n < 10 ? evh : odh; break;
                            case 9: lst[2] = ((n >> 1) & 1) == 0 ? evh : odh; break;
                            case 11: lst[2] = ((n >> 1) & 1) == 1 ? evh : odh; break; } break; }
                if (lv == dl - 2) lst[dl - 1] = odd ? chTen[dac[dl - 2]] : chAH[dac[dl - 2]]; // reduce last round according to dr calc
                Recursehi(lst, lv + 1); } }       // Recursively call next level

    // Recursive procedure to evaluate the lo permutations, shortcuts added to avoid generating many non-squares
    static void Recurselo(llst lst, int lv) { int lv1 = lv - 1; if (lv == dl) {  // check if on last stage of permutation
        if ((sum = ac[lv1]) > 0) if ((rt = (long)Sqrt(sum)) * rt == sum) sr.Add(sum); }  // test accumulated sum, append to result if square
        else foreach (int n in lst[lv]) {  // set up next permutation
                d[lv] = n; if (lv == 0) ac[0] = pp[0] * n; else ac[lv] = ac[lv1] + pp[lv] * n; // update accumulated sum
                switch (lv) {                                            // shortcuts to be performed on designated levels
                    case 0: lst[1] = lu[ln = n]; lst[2] = l2[n]; break;  // primary level: set shortcuts for secondary level
                    case 1:                                              // secondary level: set shortcuts for tertiary level
                        switch (ln) {       // for difs
                            case 1: lst[2] = (((n + 9) >> 1) & 1) == 0 ? evl : odl; break;
                            case 5: lst[2] = n < 0 ? evl : odl; break; } break; }
                Recurselo(lst, lv + 1); } }       // Recursively call next level

   // Produces a list of candidate square numbers
    static List<long> listEm(llst lst, llst plu, llst pl2) {
        d = new int[dl = lst.Count]; sr.Clear(); lu = plu; l2 = pl2; ac = new long[dl]; dac = new int[dl]; // init support vars
        pp = new long[dl]; for (int i = 0, j = nd1; i < dl; i++, j--) pp[i] = lst[0].Length > 6 ? p[j] +  p[i] : p[j] - p[i]; // build coefficients array
        if (nd <= 5) RecurseLE5(lst, 0); else { if (lst[0].Length > 8) Recursehi(lst, 0); else Recurselo(lst, 0); } return sr; } // call appropriate recursive procedure

    // Reveals whether combining two lists of squares can produce a Rare number
    static void Reveal(List<long> lo, List<long> hi) { List<string> s = new List<string>(); // create temp list of results
        foreach (long l in lo) foreach (long h in hi) { long r = (h - l) >> 1, f = h - r;   // generate all possible fwd & rev candidates from lists
                if (IsRev(nd, f, r)) s.Add(string.Format("{0,20} {1,11} {2,10}  ", f, ISR(h), ISR(l))); } // test and append sucesses to temp list
        s.Sort(); if (s.Count > 0) foreach (string t in s)                                                // if there are any, output sorted results
                Write("{0,2} {1}{2}", ++cn, t, t == s.Last() ? "" : "\n"); else Write("{0,48}", ""); }

    static void Main(string[] args) {
        WriteLine("{0,3}{1,20} {2,11} {3,10}  {4,4}{5,16} {6, 17}", "nth", "forward", "rt.sum", "rt.dif", "digs", "block time", "total time");
        p[0] = 1; for (int i = 0, j = 1; j < p.Length; i = j++) p[j] = p[i] * 10;       // create powers of 10 array
        for (int i = 0; i < drar.Length; i++) drar[i] = (i << 1) % 9; // create digital root array
        llst lls = new llst { tlo }, hls = new llst { thi }; sw.Start(); swt.Start();   // initialize permutations list, timers
        for (; nd <= 18; nd1 = nd++, odd = !odd) {                                      // loop through all numbers of digits
            if (nd > 2) if (odd) hls.Add(ten); else { lls.Add(all); hls[hls.Count - 1] = alh; } // build permutations list
            Reveal(listEm(lls, lul, l2l).ToList(), listEm(hls, luh, l2h));   // reveal results
            if (!odd && nd > 5) hls[hls.Count - 1] = alh; // restore last element of hls, so that dr shortcut doesn't mess up next nd
            WriteLine("{0,2}: {1}  {2}", nd, sw.Elapsed, swt.Elapsed); sw.Restart(); }
        // 19
        hls.Add(ten);
        Reveal(listEmU(lls, lul, l2l).ToList(), listEmU(hls, luh, l2h));   // reveal unsigned results
        WriteLine("{0,2}: {1}  {2}", nd, sw.Elapsed, swt.Elapsed);
    }
    #region 19
    static ulong usum,   // unsigned calculated sum of terms (square candidate)
        urt;             // unsigned root of sum
    static ulong[] acu,  // unsigned accumulator array
        ppu;             // unsigned long coefficient array that combines with digits of working array
    static List<ulong> sru = new List<ulong>();  // unsigned temporary list of squares used for building

    // Reveals whether combining two lists of unsigned squares can produce a Rare number
    static void Reveal(List<ulong> lo, List<ulong> hi) {
        List<string> s = new List<string>(); // create temp list of results
        foreach (ulong l in lo) foreach (ulong h in hi) { ulong r = (h - l) >> 1, f = h - r;   // generate all possible fwd & rev candidates from lists
                if (IsRev(nd, f, r)) s.Add(string.Format("{0,20} {1,11} {2,10}  ", f, ISR(h), ISR(l))); } // test and append sucesses to temp list
        s.Sort(); if (s.Count > 0) foreach (string t in s)                                                   // if there are any, output sorted results
                Write("{0,2} {1}{2}", ++cn, t, t == s.Last() ? "" : "\n"); else Write("{0,48}", ""); }

    // Produces a list of unsigned candidate square numbers
    static List<ulong> listEmU(llst lst, llst plu, llst pl2) {
        d = new int[dl = lst.Count]; sru.Clear(); lu = plu; l2 = pl2; acu = new ulong[dl]; dac = new int[dl];  // init support vars
        ppu = new ulong[dl]; for (int i = 0, j = nd1; i < dl; i++, j--) ppu[i] = (ulong)(lst[0].Length > 6 ? p[j] + p[i] : p[j] - p[i]);  // build coefficients array
        if (lst[0].Length > 8) RecurseUhi(lst, 0); else RecurseUlo(lst, 0); return sru; } // call recursive procedure

    // Recursive procedure to evaluate the unsigned hi permutations, shortcuts added to avoid generating many non-squares, digital root calc added
    static void RecurseUhi(llst lst, int lv) { int lv1 = lv - 1; if (lv == dl) {  // check if on last stage of permutation
            if ((0x202021202030213 & (1 << (int)((usum = acu[lv1]) & 63))) != 0)  // test accumulated sum, append to result if square
                if ((urt = (ulong)Sqrt(usum)) * urt == usum) sru.Add(usum); }
            else foreach (int n in lst[lv]) {  // set up next permutation
                d[lv] = n; if (lv == 0) { acu[0] = ppu[0] * (uint)n; dac[0] = drar[n]; }  // update accumulated sum and running dr
                else { acu[lv] = n >= 0 ? acu[lv1] + ppu[lv] * (uint)n : acu[lv1] - ppu[lv] * (uint)-n; dac[lv] = dac[lv1] + drar[n]; if (dac[lv] > 8) dac[lv] -= 9; }
                switch (lv) {                                            // shortcuts to be performed on designated levels
                    case 0: lst[1] = lu[ln = n]; lst[2] = l2[n]; break;  // primary level: set shortcuts for secondary level
                    case 1:                                              // secondary level: set shortcuts for tertiary level
                        switch (ln) {  // for sums
                            case 5: case 15: lst[2] = n < 10 ? evh : odh; break;
                            case 9: lst[2] = ((n >> 1) & 1) == 0 ? evh : odh; break;
                            case 11: lst[2] = ((n >> 1) & 1) == 1 ? evh : odh; break; } break; }
            if (lv == dl - 2) lst[dl - 1] = odd ? chTen[dac[dl - 2]] : chAH[dac[dl - 2]]; // reduce last round according to dr calc
            RecurseUhi(lst, lv + 1); } }       // Recursively call next level

    // Recursive procedure to evaluate the unsigned lo permutations, shortcuts added to avoid generating many non-squares
    static void RecurseUlo(llst lst, int lv) { int lv1 = lv - 1; if (lv == dl) {  // check if on last stage of permutation
            if ((usum = acu[lv1]) > 0) if ((urt = (ulong)Sqrt(usum)) * urt == usum) sru.Add(usum); }  // test accumulated sum, append to result if square
            else foreach (int n in lst[lv]) {  // set up next permutation
                d[lv] = n; if (lv == 0) acu[0] = ppu[0] * (uint)n;
                else acu[lv] = n >= 0 ? acu[lv1] + ppu[lv] * (uint)n : acu[lv1] - ppu[lv] * (uint)-n; // update accumulated sum
                switch (lv) {                                            // shortcuts to be performed on designated levels
                    case 0: lst[1] = lu[ln = n]; lst[2] = l2[n]; break;  // primary level: set shortcuts for secondary level
                    case 1:                                              // secondary level: set shortcuts for tertiary level
                        switch (ln) {       // for difs
                            case 1: lst[2] = (((n + 9) >> 1) & 1) == 0 ? evl : odl; break;
                            case 5: lst[2] = n < 0 ? evl : odl; break; } break; }
            RecurseUlo(lst, lv + 1); } }       // Recursively call next level

    // Returns unsigned Integer Square Root
    static ulong ISR(ulong s) { return (ulong)Sqrt(s); }

    // Recursively determines whether "r" is the reverse of "f"
    static bool IsRev(int nd, ulong f, ulong r) { nd--; return f / (ulong)p[nd] != r % 10 ? false : (nd < 1 ? true : IsRev(nd, f % (ulong)p[nd], r / 10)); }
    #endregion 19
}
