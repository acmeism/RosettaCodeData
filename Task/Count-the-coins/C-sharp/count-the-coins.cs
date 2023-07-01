    // Adapted from http://www.geeksforgeeks.org/dynamic-programming-set-7-coin-change/
    class Program
    {
        static long Count(int[] C, int m, int n)
        {
            var table = new long[n + 1];
            table[0] = 1;
            for (int i = 0; i < m; i++)
                for (int j = C[i]; j <= n; j++)
                    table[j] += table[j - C[i]];
            return table[n];
        }
        static void Main(string[] args)
        {
            var C = new int[] { 1, 5, 10, 25 };
            int m = C.Length;
            int n = 100;
            Console.WriteLine(Count(C, m, n));  //242
            Console.ReadLine();
        }
    }
