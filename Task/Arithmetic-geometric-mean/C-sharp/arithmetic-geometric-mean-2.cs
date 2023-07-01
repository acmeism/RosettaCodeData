using System;
 
class Program {
 
    static Decimal DecSqRoot(Decimal v) {
        Decimal r = (Decimal)Math.Sqrt((double)v), t = 0, d = 0, ld = 1;
        while (ld != d) { t = v / r; r = (r + t) / 2;
            ld = d; d = t - r; } return t; }
 
    static Decimal CalcAGM(Decimal a, Decimal b) {
        Decimal c, d = 0, ld = 1; while (ld != d) { ld = d; c = a;
            d = (a = (a + b) / 2) - (b = DecSqRoot(c * b)); } return b; }
 
    static void Main(string[] args) {
        Console.WriteLine(CalcAGM(1M, DecSqRoot(0.5M)));
        if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
    }
}
