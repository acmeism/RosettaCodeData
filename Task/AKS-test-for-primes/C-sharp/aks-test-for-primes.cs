using System;
    public class AksTest
    {
        static long[] c = new long[100];

        static void Main(string[] args)
        {
        for (int n = 0; n < 10; n++) {
		coef(n);
		Console.Write("(x-1)^" + n + " = ");
		show(n);
		Console.WriteLine("");
	}	
	   Console.Write("Primes:");
	  for (int n = 1; n <= 63; n++)
	     if (is_prime(n))
	       Console.Write(n + " ");
	
	    Console.WriteLine('\n');
            Console.ReadLine();
        }

        static void coef(int n)
        {
            int i, j;

            if (n < 0 || n > 63) System.Environment.Exit(0);// gracefully deal with range issue

            for (c[i = 0] = 1L; i < n; c[0] = -c[0], i++)
                for (c[1 + (j = i)] = 1L; j > 0; j--)
                    c[j] = c[j - 1] - c[j];
        }

        static bool is_prime(int n)
        {
            int i;

            coef(n);
            c[0] += 1;
            c[i = n] -= 1;

            while (i-- != 0 && (c[i] % n) == 0) ;

            return i < 0;
        }

        static void show(int n)
	    {
		    do {
                Console.Write("+" + c[n] + "x^" + n);
		    }while (n-- != 0);
	    }
    }
