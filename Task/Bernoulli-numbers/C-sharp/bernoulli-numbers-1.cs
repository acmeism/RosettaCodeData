using Mpir.NET;
using System;

namespace Bernoulli
{
    class Program
    {
        private static void bernoulli(mpq_t rop, uint n)
        {
            mpq_t[] a = new mpq_t[n + 1];

            for (uint i = 0; i < n + 1; i++)
            {
                a[i] = new mpq_t();
            }

            for (uint m = 0; m <= n; ++m)
            {
                mpir.mpq_set_ui(a[m], 1, m + 1);

                for (uint j = m; j > 0; --j)
                {
                    mpir.mpq_sub(a[j - 1], a[j], a[j - 1]);
                    mpir.mpq_set_ui(rop, j, 1);
                    mpir.mpq_mul(a[j - 1], a[j - 1], rop);
                }

                mpir.mpq_set(rop, a[0]);
            }
        }

        static void Main(string[] args)
        {
            mpq_t rop = new mpq_t();
            mpz_t n = new mpz_t();
            mpz_t d = new mpz_t();

            for (uint  i = 0; i <= 60; ++i)
            {
                bernoulli(rop, i);

                if (mpir.mpq_cmp_ui(rop, 0, 1) != 0)
                {
                    mpir.mpq_get_num(n, rop);
                    mpir.mpq_get_den(d, rop);
                    Console.WriteLine(string.Format("B({0, 2}) = {1, 44} / {2}", i, n, d));
                }
            }

            Console.ReadKey();
        }
    }
}
