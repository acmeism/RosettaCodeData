using System;

class Calc_E
{

    static Decimal CalcE()
    {
        Decimal f = 1, e = 2; int n = 1;
        do e += (f = f / ++n); while (f > 1e-27M);
        return e;
    }

    static void Main()
    {
        Console.WriteLine(Math.Exp(1)); // double precision built-in result
        Console.WriteLine(CalcE());  // Decimal precision result
    }
}
