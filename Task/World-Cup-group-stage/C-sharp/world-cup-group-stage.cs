using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using static System.Console;
using static System.Linq.Enumerable;

namespace WorldCupGroupStage
{
    public static class WorldCupGroupStage
    {
        static int[][] _histogram;

        static WorldCupGroupStage()
        {
            int[] scoring = new[] { 0, 1, 3 };

            _histogram = Repeat<Func<int[]>>(()=>new int[10], 4).Select(f=>f()).ToArray();

            var teamCombos = Range(0, 4).Combinations(2).Select(t2=>t2.ToArray()).ToList();

            foreach (var results in Range(0, 3).CartesianProduct(6))
            {
                var points = new int[4];

                foreach (var (result, teams) in results.Zip(teamCombos, (r, t) => (r, t)))
                {
                    points[teams[0]] += scoring[result];
                    points[teams[1]] += scoring[2 - result];
                }

                foreach(var (p,i) in points.OrderByDescending(a => a).Select((p,i)=>(p,i)))
                    _histogram[i][p]++;
            }
        }

       // https://gist.github.com/martinfreedman/139dd0ec7df4737651482241e48b062f

       static IEnumerable<IEnumerable<T>> CartesianProduct<T>(this IEnumerable<IEnumerable<T>> seqs) =>
            seqs.Aggregate(Empty<T>().ToSingleton(), (acc, sq) => acc.SelectMany(a => sq.Select(s => a.Append(s))));

       static IEnumerable<IEnumerable<T>> CartesianProduct<T>(this IEnumerable<T> seq, int repeat = 1) =>
            Repeat(seq, repeat).CartesianProduct();

       static IEnumerable<IEnumerable<T>> Combinations<T>(this IEnumerable<T> seq) =>
            seq.Aggregate(Empty<T>().ToSingleton(), (a, b) => a.Concat(a.Select(x => x.Append(b))));

       static IEnumerable<IEnumerable<T>> Combinations<T>(this IEnumerable<T> seq, int numItems) =>
            seq.Combinations().Where(s => s.Count() == numItems);

        private static IEnumerable<T> ToSingleton<T>(this T item) { yield return item; }

        static new string ToString()
        {
            var sb = new StringBuilder();

            var range = String.Concat(Range(0, 10).Select(i => $"{i,-3} "));
            sb.AppendLine($"Points      : {range}");

            var u = String.Concat(Repeat("─", 40+13));
            sb.AppendLine($"{u}");

            var places = new[] { "First", "Second", "Third", "Fourth" };
            foreach (var row in _histogram.Select((r, i) => (r, i)))
            {
                sb.Append($"{places[row.i],-6} place: ");
                foreach (var standing in row.r)
                    sb.Append($"{standing,-3} ");
                sb.Append("\n");
            }

            return sb.ToString();
        }

        static void Main(string[] args)
        {
            Write(ToString());
            Read();
        }
    }
}
