using System;
using UI = System.UInt64;

class Program {

    // write a range (1..num) to the console when num < 0, just write the nth when num > 0, otherwise write the digits tabulation
    // note: when doing range or nth, if num > ~1e19 the results will appear incorrect as UInt64 can't express numbers that large
    static void humLog(int digs, int num = 0) {
        bool range = num < 0, nth = num > 0, small = range | nth; num = Math.Abs(num);
        int maxdim = num;
        if (range | nth) digs = num.ToString().Length; // calculate number of digits when range or nth is specified
        //const int maxdim = 2_147_483_647; // 2GB limit (Int32.MaxValue), causes out of memory error
        //const int maxdim = 2_146_435_071; // max practical amount
        //const int maxdim = 2_114_620_032; // amount needed for 255 digits
        else maxdim = 2_114_620_032;
        const double fac = 1e11;
        UI lb2 = (UI)Math.Round(fac * Math.Log(2)), lb3 = (UI)Math.Round(fac * Math.Log(3)), lb5 = (UI)Math.Round(fac * Math.Log(5)),
           lb7 = (UI)Math.Round(fac * Math.Log(7)), lb0 = (UI)Math.Round(fac * Math.Log(10)), hm,
           x2 = lb2, x3 = lb3, x5 = lb5, x7 = lb7, lim = lb0;
        int i = 0, j = 0, k = 0, l = 0, lc = 0, d = 1, hi = 1;
        UI[] h = new UI[maxdim]; h[0] = 1;
        var st = DateTime.Now.Ticks;
        if (range) Console.Write("The first {0} humble numbers are: 1 ", num);
        else if (nth) Console.Write("The {0}{1} humble number is ", num, (num % 10) switch { 1 => "st", 2 => "nd", 3 => "rd", _ => "th", });
        else Console.WriteLine("\nDigits  Dig Count        Tot Count      Time    Mb used");
        do { hm = x2; if (x3 < hm) hm = x3; if (x5 < hm) hm = x5; if (x7 < hm) hm = x7; // select the minimum
            if (hm >= lim && !small) { // passed another decade, so output results
                Console.WriteLine("{0,3} {1,13:n0} {4,16:n0} {2,9:n3}s {3,9:n0}", d, hi - lc,
                    ((DateTime.Now.Ticks - st) / 10000)/1000.0, GC.GetTotalMemory(false) / 1000000, hi);
                lc = hi; if (++d > digs) break; lim += lb0; }
            h[hi++] = (hm); if (small) { if (nth && hi == num) { Console.WriteLine(Math.Round(Math.Exp(hm / fac))); break; }
                if (range) { Console.Write("{0} ", Math.Round(Math.Exp(hm / fac))); if (hi == num) { Console.WriteLine(); break; } } }
            if (hm == x2) x2 = h[++i] + lb2;  if (hm == x3) x3 = h[++j] + lb3;
            if (hm == x5) x5 = h[++k] + lb5;  if (hm == x7) x7 = h[++l] + lb7;
        } while (true);
        if (!(range | nth)) Console.WriteLine("{0,17:n0} Total", lc);
    }
    static void Main(string[] args) {
        humLog(0, -50);  // see the range 1..50
        humLog(255);     // see tabulation for digits 1 to 255
     }
}
