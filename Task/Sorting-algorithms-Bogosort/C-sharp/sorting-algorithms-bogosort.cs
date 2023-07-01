using System;
using System.Collections.Generic;

namespace RosettaCode.BogoSort
{
    public static class BogoSorter
    {
        public static void Sort<T>(List<T> list) where T:IComparable
        {
            while (!list.isSorted())
            {
                list.Shuffle();
            }
        }

        private static bool isSorted<T>(this IList<T> list) where T:IComparable
        {
            if(list.Count<=1)
                return true;
            for (int i = 1 ; i < list.Count; i++)
                if(list[i].CompareTo(list[i-1])<0) return false;
            return true;
        }

        private static void Shuffle<T>(this IList<T> list)
        {
            Random rand = new Random();
            for (int i = 0; i < list.Count; i++)
            {
                int swapIndex = rand.Next(list.Count);
                T temp = list[swapIndex];
                list[swapIndex] = list[i];
                list[i] = temp;
            }
        }
    }

    class TestProgram
    {
        static void Main()
        {
            List<int> testList = new List<int> { 3, 4, 1, 8, 7, 4, -2 };
            BogoSorter.Sort(testList);
            foreach (int i in testList) Console.Write(i + " ");
        }

    }
}
