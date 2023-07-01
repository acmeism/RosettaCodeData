using System.Collections.Generic;
using System.Linq;
using static System.Console;
namespace RunLengthEncoding
{
    static class Program
    {
         public static string Encode(string input) => input.Length ==0 ? "" : input.Skip(1)
            .Aggregate((t:input[0].ToString(),o:Empty<string>()),
               (a,c)=>a.t[0]==c ? (a.t+c,a.o) : (c.ToString(),a.o.Append(a.t)),
               a=>a.o.Append(a.t).Select(p => (key: p.Length, chr: p[0])));

        public static string Decode(IEnumerable<(int i , char c)> input) =>
            string.Concat(input.Select(t => new string(t.c, t.i)));

        public static void Main(string[] args)
        {
            const string  raw = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";
            var encoded = new[] { (12, 'W'), (1, 'B'), (12, 'W'), (3, 'B'), (24, 'W'), (1, 'B'), (14, 'W') };

            WriteLine($"raw = {raw}");
            WriteLine($"Encode(raw) = encoded = {Encode(raw).TupleListToString()}");
            WriteLine($"Decode(encoded) = {Decode(encoded)}");
            WriteLine($"Decode(Encode(raw)) = {Decode(Encode(raw)) == raw}");
            ReadLine();
        }
        private static string TupleListToString(this IEnumerable<(int i, char c)> list) =>
            string.Join(",", list.Select(t => $"[{t.i},{t.c}]"));
    }
}
