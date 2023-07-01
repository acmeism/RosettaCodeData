namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            for (int x = 0; x < 10; x++)
            {
                Console.WriteLine("In: {0:0.00}, Out: {1:0.00}", ((double)x) / 10, SpecialRound(((double)x) / 10));
            }

            Console.WriteLine();

            for (int x = 0; x < 10; x++)
            {
                Console.WriteLine("In: {0:0.00}, Out: {1:0.00}", ((double)x) / 10 + 0.05, SpecialRound(((double)x) / 10 + 0.05));
            }

            Console.WriteLine();
            Console.WriteLine("In: {0:0.00}, Out: {1:0.00}", 1.01, SpecialRound(1.01));

            Console.Read();
        }

        private static double SpecialRound(double inValue)
        {
            if (inValue > 1) return 1;

            double[] Splitters = new double[] {
                   0.00 , 0.06 , 0.11 , 0.16 , 0.21 ,
                   0.26 , 0.31 , 0.36 , 0.41 , 0.46 ,
                   0.51 , 0.56 , 0.61 , 0.66 , 0.71 ,
                   0.76 , 0.81 , 0.86 , 0.91 , 0.96 };

            double[] replacements = new double[] {
                    0.10 , 0.18 , 0.26 , 0.32 , 0.38 ,
                    0.44 , 0.50 , 0.54 , 0.58 , 0.62 ,
                    0.66 , 0.70 , 0.74 , 0.78 , 0.82 ,
                    0.86 , 0.90 , 0.94 , 0.98 , 1.00 };

            for (int x = 0; x < Splitters.Length - 1; x++)
            {
                if (inValue >= Splitters[x] &&
                    inValue < Splitters[x + 1])
                {
                    return replacements[x];
                }
            }

            return inValue;
        }
    }
}
