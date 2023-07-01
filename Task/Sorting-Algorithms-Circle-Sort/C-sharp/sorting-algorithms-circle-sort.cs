using System;
using System.Linq;

namespace CircleSort
{
    internal class Program
    {
        public static int[] CircleSort(int[] array)
        {
            if (array.Length > 0)
                while (CircleSortR(array, 0, array.Length - 1, 0) != 0)
                    continue;
            return array;
        }

        private static int CircleSortR(int[] arr, int lo, int hi, int numSwaps)
        {
            if (lo == hi)
                return numSwaps;

            var high = hi;
            var low = lo;
            var mid = (hi - lo) / 2;

            while (lo < hi)
            {
                if (arr[lo] > arr[hi])
                {
                    (arr[lo], arr[hi]) = (arr[hi], arr[lo]);
                    numSwaps++;
                }
                lo++;
                hi--;
            }

            if (lo == hi && arr[lo] > arr[hi + 1])
            {
                (arr[lo], arr[hi + 1]) = (arr[hi + 1], arr[lo]);
                numSwaps++;
            }

            numSwaps = CircleSortR(arr, low, low + mid, numSwaps);
            numSwaps = CircleSortR(arr, low + mid + 1, high, numSwaps);

            return numSwaps;
        }

        private static void Main(string[] args)
        {
            var sortedArray = CircleSort(new int[] { 6, 7, 8, 9, 2, 5, 3, 4, 1 });
            sortedArray.ToList().ForEach(i => Console.Write(i.ToString() + " "));
            Console.WriteLine();
            var sortedArray2 = CircleSort(new int[] { 2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1 });
            sortedArray2.ToList().ForEach(i => Console.Write(i.ToString() + " "));
            Console.WriteLine();
            var sortedArray3 = CircleSort(new int[] { 2, 3, 3, 5, 5, 1, 1, 7, 7, 6, 6, 4, 4, 0, 0 });
            sortedArray3.ToList().ForEach(i => Console.Write(i.ToString() + " "));
            Console.ReadKey();
        }
    }
}
