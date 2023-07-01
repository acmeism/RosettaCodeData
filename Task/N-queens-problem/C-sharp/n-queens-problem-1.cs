using System.Collections.Generic;
using static System.Linq.Enumerable;
using static System.Console;
using static System.Math;

namespace N_Queens
{
    static class Program
    {
        static void Main(string[] args)
        {
            var n = 8;
            var cols = Range(0, n);
            var combs = cols.Combinations(2).Select(pairs=> pairs.ToArray());
            var solved = from v in cols.Permutations().Select(p => p.ToArray())
                         where combs.All(c => Abs(v[c[0]] - v[c[1]]) != Abs(c[0] - c[1]))
                         select v;

            WriteLine($"{n}-queens has {solved.Count()} solutions");
            WriteLine("Position is row, value is column:-");
            var first = string.Join(" ", solved.First());
            WriteLine($"First Solution: {first}");
            Read();
        }

        //Helpers
        public static IEnumerable<IEnumerable<T>> Permutations<T>(this IEnumerable<T> values)
        {
            if (values.Count() == 1)
                return values.ToSingleton();

            return values.SelectMany(v => Permutations(values.Except(v.ToSingleton())), (v, p) => p.Prepend(v));
        }

        public static IEnumerable<IEnumerable<T>> Combinations<T>(this IEnumerable<T> seq) =>
            seq.Aggregate(Empty<T>().ToSingleton(), (a, b) => a.Concat(a.Select(x => x.Append(b))));

        public static IEnumerable<IEnumerable<T>> Combinations<T>(this IEnumerable<T> seq, int numItems) =>
            seq.Combinations().Where(s => s.Count() == numItems);

        public static IEnumerable<T> ToSingleton<T>(this T item) { yield return item; }
    }
}
