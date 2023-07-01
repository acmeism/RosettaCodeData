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
            var solved = from v in cols.Permutations().Select(p => p.ToArray())
                         where n == (from i in cols select v[i]+i).Distinct().Count()
                         where n == (from i in cols select v[i]-i).Distinct().Count()
                         select v;

            WriteLine($"{n}-queens has {solved.Count()} solutions");
            WriteLine("Position is row, value is column:-");
            var first = string.Join(" ", solved.First());
            WriteLine($"First Solution: {first}");
            Read();
        }

        //Helpers from https://gist.github.com/martinfreedman/139dd0ec7df4737651482241e48b062f

        public static IEnumerable<IEnumerable<T>> Permutations<T>(this IEnumerable<T> values)
        {
            if (values.Count() == 1)
                return values.ToSingleton();

            return values.SelectMany(v => Permutations(values.Except(v.ToSingleton())), (v, p) => p.Prepend(v));
        }

        public static IEnumerable<T> ToSingleton<T>(this T item) { yield return item; }
    }
}
