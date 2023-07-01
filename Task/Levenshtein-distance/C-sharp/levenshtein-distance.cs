using System;

namespace LevenshteinDistance
{
    class Program
    {
        static int LevenshteinDistance(string s, string t)
        {
            int n = s.Length;
            int m = t.Length;
            int[,] d = new int[n + 1, m + 1];
		
	    if (n == 0)
	    {
		return m;
	    }
	
	    if (m == 0)
	    {
		return n;
	    }

            for (int i = 0; i <= n; i++)
                d[i, 0] = i;
            for (int j = 0; j <= m; j++)
                d[0, j] = j;
			
            for (int j = 1; j <= m; j++)
                for (int i = 1; i <= n; i++)
                    if (s[i - 1] == t[j - 1])
                        d[i, j] = d[i - 1, j - 1];  //no operation
                    else
                        d[i, j] = Math.Min(Math.Min(
                            d[i - 1, j] + 1,    //a deletion
                            d[i, j - 1] + 1),   //an insertion
                            d[i - 1, j - 1] + 1 //a substitution
                            );
            return d[n, m];
        }

        static void Main(string[] args)
        {
            if (args.Length == 2)
                Console.WriteLine("{0} -> {1} = {2}",
                    args[0], args[1], LevenshteinDistance(args[0], args[1]));
            else
                Console.WriteLine("Usage:-\n\nLevenshteinDistance <string1> <string2>");
        }
    }
}
