using System;
using System.Linq;

namespace CountingSort
{
    class Program
    {
        static void Main(string[] args)
        {
            Random rand = new Random();                                   // Just for creating a test array
            int[] arr = new int[100];                                     // of random numbers
            for (int i = 0; i < 100; i++) { arr[i] = rand.Next(0, 100); } // ...

            int[] newarr = countingSort(arr, arr.Min(), arr.Max());
        }

        private static int[] countingSort(int[] arr, int min, int max)
        {
            int[] count = new int[max - min + 1];
            int z = 0;

            for (int i = 0; i < count.Length; i++) { count[i] = 0; }
            for (int i = 0; i < arr.Length; i++) { count[arr[i] - min]++; }

            for (int i = min; i <= max; i++)
            {
                while (count[i - min]-- > 0)
                {
                    arr[z] = i;
                    z++;
                }
            }
            return arr;
        }
    }
}
