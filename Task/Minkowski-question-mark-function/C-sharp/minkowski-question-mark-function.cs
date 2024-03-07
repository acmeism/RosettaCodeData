using System;

class Program
{
    const int MAXITER = 151;

    static double Minkowski(double x)
    {
        if (x > 1 || x < 0)
        {
            return Math.Floor(x) + Minkowski(x - Math.Floor(x));
        }
        ulong p = (ulong)x;
        ulong q = 1;
        ulong r = p + 1;
        ulong s = 1;
        double d = 1.0;
        double y = (double)p;
        while (true)
        {
            d = d / 2;
            if (y + d == y)
            {
                break;
            }
            ulong m = p + r;
            if (m < 0 || p < 0)
            {
                break;
            }
            ulong n = q + s;
            if (n < 0)
            {
                break;
            }
            if (x < (double)m / (double)n)
            {
                r = m;
                s = n;
            }
            else
            {
                y = y + d;
                p = m;
                q = n;
            }
        }
        return y + d;
    }

    static double MinkowskiInv(double x)
    {
        if (x > 1 || x < 0)
        {
            return Math.Floor(x) + MinkowskiInv(x - Math.Floor(x));
        }
        if (x == 1 || x == 0)
        {
            return x;
        }
        uint[] contFrac = new uint[] { 0 };
        uint curr = 0;
        uint count = 1;
        int i = 0;
        while (true)
        {
            x *= 2;
            if (curr == 0)
            {
                if (x < 1)
                {
                    count++;
                }
                else
                {
                    i++;
                    Array.Resize(ref contFrac, i + 1);
                    contFrac[i - 1] = count;
                    count = 1;
                    curr = 1;
                    x--;
                }
            }
            else
            {
                if (x > 1)
                {
                    count++;
                    x--;
                }
                else
                {
                    i++;
                    Array.Resize(ref contFrac, i + 1);
                    contFrac[i - 1] = count;
                    count = 1;
                    curr = 0;
                }
            }
            if (x == Math.Floor(x))
            {
                contFrac[i] = count;
                break;
            }
            if (i == MAXITER)
            {
                break;
            }
        }
        double ret = 1.0 / contFrac[i];
        for (int j = i - 1; j >= 0; j--)
        {
            ret = contFrac[j] + 1.0 / ret;
        }
        return 1.0 / ret;
    }

    static void Main(string[] args)
    {
        Console.WriteLine("{0,19:0.0000000000000000} {1,19:0.0000000000000000}", Minkowski(0.5 * (1 + Math.Sqrt(5))), 5.0 / 3.0);
        Console.WriteLine("{0,19:0.0000000000000000} {1,19:0.0000000000000000}", MinkowskiInv(-5.0 / 9.0), (Math.Sqrt(13) - 7) / 6);
        Console.WriteLine("{0,19:0.0000000000000000} {1,19:0.0000000000000000}", Minkowski(MinkowskiInv(0.718281828)),
            MinkowskiInv(Minkowski(0.1213141516171819)));
    }
}
