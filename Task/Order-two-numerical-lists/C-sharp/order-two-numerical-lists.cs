namespace RosettaCode.OrderTwoNumericalLists
{
    using System;
    using System.Collections.Generic;

    internal static class Program
    {
        private static bool IsLessThan(this IEnumerable<int> enumerable,
            IEnumerable<int> otherEnumerable)
        {
            using (
                IEnumerator<int> enumerator = enumerable.GetEnumerator(),
                    otherEnumerator = otherEnumerable.GetEnumerator())
            {
                while (true)
                {
                    if (!otherEnumerator.MoveNext())
                    {
                        return false;
                    }

                    if (!enumerator.MoveNext())
                    {
                        return true;
                    }

                    if (enumerator.Current == otherEnumerator.Current)
                    {
                        continue;
                    }

                    return enumerator.Current < otherEnumerator.Current;
                }
            }
        }

        private static void Main()
        {
            Console.WriteLine(
                new[] {1, 2, 1, 3, 2}.IsLessThan(new[] {1, 2, 0, 4, 4, 0, 0, 0}));
        }
    }
}
