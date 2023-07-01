using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaCode
{
    static class StreamMerge
    {
        static IEnumerable<T> Merge2<T>(IEnumerable<T> source1, IEnumerable<T> source2) where T : IComparable
        {
            var q1 = new Queue<T>(source1);
            var q2 = new Queue<T>(source2);
            while (q1.Any() && q2.Any())
            {
                var c = q1.Peek().CompareTo(q2.Peek());
                if (c <= 0) yield return q1.Dequeue(); else yield return q2.Dequeue();
            }
            while (q1.Any()) yield return q1.Dequeue();
            while (q2.Any()) yield return q2.Dequeue();
        }

        static IEnumerable<T> MergeN<T>(params IEnumerable<T>[] sources) where T : IComparable
        {
            var queues = sources.Select(e => new Queue<T>(e)).Where(q => q.Any()).ToList();
            var headComparer = Comparer<Queue<T>>.Create((x, y) => x.Peek().CompareTo(y.Peek()));
            queues.Sort(headComparer);

            while (queues.Any())
            {
                var q = queues.First();
                queues.RemoveAt(0);
                yield return q.Dequeue();
                if (q.Any())
                {
                    var index = queues.BinarySearch(q, headComparer);
                    queues.Insert(index < 0 ? ~index : index, q);
                }
            }
        }

        static void Main()
        {
            var a = new[] { 1, 4, 7, 10 };
            var b = new[] { 2, 5, 8, 11 };
            var c = new[] { 3, 6, 9, 12 };

            foreach (var i in Merge2(a, b)) Console.Write($"{i} ");
            Console.WriteLine();

            foreach (var i in MergeN(a, b, c)) Console.Write($"{i} ");
            Console.WriteLine();
        }
    }
}
