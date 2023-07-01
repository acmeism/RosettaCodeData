using System;
class Program
{
    public static long Ackermann(long m, long n)
    {
        if(m > 0)
        {
            if (n > 0)
                return Ackermann(m - 1, Ackermann(m, n - 1));
            else if (n == 0)
                return Ackermann(m - 1, 1);
        }
        else if(m == 0)
        {
            if(n >= 0)
                return n + 1;
        }

        throw new System.ArgumentOutOfRangeException();
    }

    static void Main()
    {
        for (long m = 0; m <= 3; ++m)
        {
            for (long n = 0; n <= 4; ++n)
            {
                Console.WriteLine("Ackermann({0}, {1}) = {2}", m, n, Ackermann(m, n));
            }
        }
    }
}
