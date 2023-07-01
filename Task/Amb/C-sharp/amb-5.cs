using static System.Console;
using System.Linq;

string[] w1 = { "the", "that", "a" };
string[] w2 = { "frog", "elephant", "thing" };
string[] w3 = { "walked", "treaded", "grows" };
string[] w4 = { "slowly", "quickly" };

var result = from a in w1
             join b in w2 on a?.LastOrDefault() equals b?.FirstOrDefault()
             join c in w3 on b?.LastOrDefault() equals c?.FirstOrDefault()
             join d in w4 on c?.LastOrDefault() equals d?.FirstOrDefault()
             select new [] {a, b, c, d};
WriteLine(string.Join(" ", result.SelectMany(x => x)));

double[] x = { 1, 2, 3 };
double[] y = { 7, 6, 4, 5 };

var result2 = from a in x
              join b in y on a equals 8 / b
              select new[] { a, b };
WriteLine(string.Join(" ", result2.SelectMany(x => x)));
