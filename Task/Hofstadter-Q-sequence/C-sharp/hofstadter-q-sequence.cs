using System;
using System.Collections.Generic;

namespace HofstadterQSequence
{
    class Program
    {
        // Initialize the dictionary with the first two indices filled.
        private static readonly Dictionary<int, int> QList = new Dictionary<int, int>
                                                                 {
                                                                     {1, 1},
                                                                     {2, 1}
                                                                 };

        private static void Main()
        {
            int lessThanLast = 0;
                /* Initialize our variable that holds the number of times
                                   * a member of the sequence was less than its preceding term. */

            for (int n = 1; n <= 100000; n++)
            {
                int q = Q(n); // Get Q(n).

                if (n > 1 && QList[n - 1] > q) // If Q(n) is less than Q(n - 1),
                    lessThanLast++;            // then add to the counter.

                if (n > 10 && n != 1000) continue; /* If n is greater than 10 and not 1000,
                                                    * the rest of the code in the loop does not apply,
                                                    * and it will be skipped. */

                if (!Confirm(n, q)) // Confirm Q(n) is correct.
                    throw new Exception(string.Format("Invalid result: Q({0}) != {1}", n, q));

                Console.WriteLine("Q({0}) = {1}", n, q); // Write Q(n) to the console.
            }

            Console.WriteLine("Number of times a member of the sequence was less than its preceding term: {0}.",
                              lessThanLast);
        }

        private static bool Confirm(int n, int value)
        {
            if (n <= 10)
                return new[] {1, 1, 2, 3, 3, 4, 5, 5, 6, 6}[n - 1] == value;
            if (n == 1000)
                return 502 == value;
            throw new ArgumentException("Invalid index.", "n");
        }

        private static int Q(int n)
        {
            int q;

            if (!QList.TryGetValue(n, out q)) // Try to get Q(n) from the dictionary.
            {
                q = Q(n - Q(n - 1)) + Q(n - Q(n - 2)); // If it's not available, then calculate it.
                QList.Add(n, q); // Add it to the dictionary.
            }

            return q;
        }
    }
}
