using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RosettaCode
{
    class Program
    {
        static void QuickSort(IComparable[] elements, int left, int right)
        {
            int i = left, j = right;
            IComparable pivot = elements[left + (right - left) / 2];

            while (i <= j)
            {
                while (elements[i].CompareTo(pivot) < 0) i++;
                while (elements[j].CompareTo(pivot) > 0) j--;

                if (i <= j)
                {
                    // Swap
                    IComparable tmp = elements[i];
                    elements[i] = elements[j];
                    elements[j] = tmp;
                    i++;
                    j--;
                }
            }

            // Recursive calls
            if (left < j) QuickSort(elements, left, j);
            if (i < right) QuickSort(elements, i, right);
        }
        const int NUMBALLS = 5;
        static void Main(string[] args)
        {
            Func<string[], bool> IsSorted = (ballList) =>
                {
                    int state = 0;
                    for (int i = 0; i < NUMBALLS; i++)
                    {
                        if (int.Parse(ballList[i]) < state)
                            return false;
                        if (int.Parse(ballList[i]) > state)
                            state = int.Parse(ballList[i]);
                    }
                    return true;
                };
            Func<string[], string> PrintOut = (ballList2) =>
                {
                    StringBuilder str = new StringBuilder();
                    for (int i = 0; i < NUMBALLS; i++)
                        str.Append(int.Parse(ballList2[i]) == 0 ? "r" : int.Parse(ballList2[i]) == 1 ? "w" : "b");
                    return str.ToString();
                };
            bool continueLoop = true;
            string[] balls = new string[NUMBALLS]; // 0 = r, 1 = w, 2 = b
            Random numberGenerator = new Random();
            do // Enforce that we start with non-sorted balls
            {
                // Generate balls
                for (int i = 0; i < NUMBALLS; i++)
                    balls[i] = numberGenerator.Next(3).ToString();

                continueLoop = IsSorted(balls);
                if (continueLoop)
                    Console.WriteLine("Accidentally still sorted: {0}", PrintOut(balls));
            } while (continueLoop);
            Console.WriteLine("Non-sorted: {0}", PrintOut(balls));
            QuickSort(balls, 0, NUMBALLS - 1); // Sort them using quicksort
            Console.WriteLine("{0}: {1}", IsSorted(balls) ? "Sorted" : "Sort failed", PrintOut(balls));
        }
    }
}
