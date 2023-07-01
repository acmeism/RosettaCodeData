using static System.Linq.Enumerable;
using static System.Console;

namespace N_Queens
{
    static class Program
    {
        static void Main(string[] args)
        {
            var n = 8;
            var domain = Range(0, n).ToArray();

            var amb = new Amb.Amb();
            var queens = domain.Select(_ => amb.Choose(domain)).ToArray();
            amb.Require(() => n == queens.Select(q=> q.Value).Distinct().Count());
            amb.Require(() => n == domain.Select(i=> i + queens[i].Value).Distinct().Count());
            amb.Require(() => n == domain.Select(i=> i - queens[i].Value).Distinct().Count());

            if (amb.Disambiguate())
            {
                WriteLine("Position is row, value is column:-");
                WriteLine(string.Join(" ", queens.AsEnumerable()));
            }
            else
                WriteLine("amb is angry");
            Read();
        }
    }
}
