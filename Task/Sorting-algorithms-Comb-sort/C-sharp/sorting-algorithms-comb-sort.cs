using System;

namespace CombSort
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] unsorted = new int[] { 3, 5, 1, 9, 7, 6, 8, 2, 4 };
            Console.WriteLine(string.Join(",", combSort(unsorted)));
        }
        public static int[] combSort(int[] input)
        {
            double gap = input.Length;
            bool swaps = true;
            while (gap > 1 || swaps)
            {
                gap /= 1.247330950103979;
                if (gap < 1) { gap = 1; }
                int i = 0;
                swaps = false;
                while (i + gap < input.Length)
                {
                    int igap = i + (int)gap;
                    if (input[i] > input[igap])
                    {
                        int swap = input[i];
                        input[i] = input[igap];
                        input[igap] = swap;
                        swaps = true;
                    }
                    i++;
                }
            }
            return input;
        }
    }
}
