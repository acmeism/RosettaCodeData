    class Program
    {
        private static Random rnd = new Random();
        public static int one_of_n(int n)
        {
            int currentChoice = 1;
            for (int i = 2; i <= n; i++)
            {
                double outerLimit = 1D / (double)i;
                if (rnd.NextDouble() < outerLimit)
                    currentChoice = i;
            }
            return currentChoice;
        }

        static void Main(string[] args)
        {
            Dictionary<int, int> results = new Dictionary<int, int>();
            for (int i = 1; i < 11; i++)
                results.Add(i, 0);

            for (int i = 0; i < 1000000; i++)
            {
                int result = one_of_n(10);
                results[result] = results[result] + 1;
            }

            for (int i = 1; i < 11; i++)
                Console.WriteLine("{0}\t{1}", i, results[i]);
            Console.ReadLine();
        }
    }
