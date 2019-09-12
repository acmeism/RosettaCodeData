using System;
using System.Numerics;

namespace agm
{
    class Program
    {
        static BigInteger BIP(char leadDig, int numDigs)
        {
            return BigInteger.Parse(leadDig + new string('0', numDigs));
        }

        static BigInteger IntSqRoot(BigInteger v)
        {
            int digs = Math.Max(0, v.ToString().Length / 2);
            BigInteger res = BIP('3', digs), term;
            while (true) {
                term = v / res; if (Math.Abs((double)(term - res)) < 2) break;
                res = (res + term) / 2; } return res;
        }

        static BigInteger CalcByAGM(int digits)
        {
            int digs = digits + (int)(Math.Log(digits) / 2), d2 = digs * 2;
            BigInteger a = BIP('1', digs),              // initial value = 1
                       b = IntSqRoot(BIP('5', d2 - 1)), // initial value = square root of 0.5
                       c;
            while (true) {
                c = a; a = ((a + b) / 2); b = IntSqRoot(c * b);
                if (Math.Abs((double)(a - b)) <= 1) break;
            }
            return b;
        }

        static void Main(string[] args)
        {
            int digits = 25000;
            if (args.Length > 0)
            {
                int.TryParse(args[0], out digits);
                if (digits < 1 || digits > 999999) digits = 25000;
            }
            Console.WriteLine("0.{0}", CalcByAGM(digits).ToString());
            if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
        }
    }
}
