using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace spiralmat
{
    class spiral
    {
        public static int lev;
        int lev_lim, count, bk, cd, low, l, m;
        spiral()
        {
            lev = lev_lim = count = bk = cd = low = l = m = 0;
        }

        void level(int n1, int r, int c)
        {
            lev_lim = n1 % 2 == 0 ? n1 / 2 : (n1 + 1) / 2;
            if ((r <= lev_lim) && (c <= lev_lim))
                lev = Math.Min(r, c);
            else
            {
                bk = r > c ? (n1 + 1) - r : (n1 + 1) - c;
                low = Math.Min(r, c);
                if (low <= lev_lim)
                    cd = low;
                lev = cd < bk ? cd : bk;
            }
        }

        int func(int n2, int xo, int lo)
        {
            l = xo;
            m = lo;
            count = 0;
            level(n2, l, m);

            for (int ak = 1; ak < lev; ak++)
                count += 4 * (n2 - 1 - 2 * (ak - 1));
            return count;
        }

        public static void Main(string[] args)
        {
            spiral ob = new spiral();
            Console.WriteLine("Enter Order..");
            int n = int.Parse(Console.ReadLine());
            Console.WriteLine("The Matrix of {0} x {1} Order is=>\n", n, n);
            for (int i = 1; i <= n; i++)
            {
                for (int j = 1; j <= n; j++)
                    Console.Write("{0,3:D} ",
		                  ob.func(n, i, j)
				  + Convert.ToInt32(
				    ((j >= i) && (i == lev))
				      ? ((j - i) + 1)
				      : ((j == ((n + 1) - lev) && (i > lev) && (i <= j)))
				        ? (n - 2 * (lev - 1) + (i - 1) - (n - j))
					: ((i == ((n + 1) - lev) && (j < i)))
					  ? ((n - 2 * (lev - 1)) + ((n - 2 * (lev - 1)) - 1) + (i - j))
					  : ((j == lev) && (i > lev) && (i < ((n + 1) - lev)))
					    ? ((n - 2 * (lev - 1)) + ((n - 2 * (lev - 1)) - 1) + ((n - 2 * (lev - 1)) - 1) + (((n + 1) - lev) - i))
					    : 0));
                Console.WriteLine();
            }
            Console.ReadKey();
        }
    }
}
