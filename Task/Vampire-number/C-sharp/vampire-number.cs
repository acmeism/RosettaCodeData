using System;

namespace RosettaVampireNumber
{
    class Program
    {
        static void Main(string[] args)
        {
            int i, j, n;
            ulong x;
            var f = new ulong[16];
            var bigs = new ulong[] { 16758243290880UL, 24959017348650UL, 14593825548650UL, 0 };
            ulong[] tens = new ulong[20];
            tens[0] = 1;
            for (i = 1; i < 20; i++)
                tens[i] = tens[i - 1] * 10;

            for (x = 1, n = 0; n < 25; x++)
            {
                if ((j = fangs(x, f, tens)) == 0) continue;
                Console.Write(++n + ": ");
                show_fangs(x, f, j);
            }

            Console.WriteLine();
            for (i = 0; bigs[i] > 0 ; i++)
            {
                if ((j = fangs(bigs[i], f, tens)) > 0)
                    show_fangs(bigs[i], f, j);
                else
                    Console.WriteLine(bigs[i] + " is not vampiric.");
            }
            Console.ReadLine();
        }

        private static void show_fangs(ulong x, ulong[] f, int cnt)
        {
            Console.Write(x);
            int i;
            for (i = 0; i < cnt; i++)
                Console.Write(" = " + f[i] + " * " + (x / f[i]));
            Console.WriteLine();
        }

        private static int fangs(ulong x, ulong[] f, ulong[] tens)
        {
            int n = 0;
            int nd = ndigits(x);
            if ((nd & 1) > 0) return 0;
            nd /= 2;

            ulong lo, hi;
            lo = Math.Max(tens[nd - 1], (x + tens[nd] - 2) / (tens[nd] - 1));
            hi = Math.Min(x / lo, (ulong) Math.Sqrt(x));

            ulong a, b, t = dtally(x);
            for (a = lo; a <= hi; a++)
            {
                b = x / a;
                if (a * b == x && ((a % 10) > 0 || (b % 10) > 0) && t == dtally(a) + dtally(b))
                    f[n++] = a;
            }

            return n;
        }

        private static ulong dtally(ulong x)
        {
            ulong t = 0;
            while (x > 0)
            {
                t += 1UL << (int)((x % 10) * 6);
                x /= 10;
            }

            return t;
        }

        private static int ndigits(ulong x)
        {
            int n = 0;
            while (x > 0)
            {
                n++;
                x /= 10;
            }
            return n;
        }
    }
}
