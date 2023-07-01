using System.Collections.Generic;
using System.Linq;
using static System.Console;
using static System.Text;

namespace RunLengthEncoding
{
    static class Program
    {
         public static string Encode(string input) => input.Length == 0 ? "" : input.Skip(1)
          .Aggregate((len: 1, chr: input[0], sb: new StringBuilder()),
             (a, c) => a.chr == c ? (a.len + 1, a.chr, a.sb)
                                  : (1, c, a.sb.Append(a.len).Append(a.chr))),
             a => a.sb.Append(a.len).Append(a.chr)))
          .ToString();

         public static string Decode(string input) => input
           .Aggregate((t: "", sb: new StringBuilder()),
             (a, c) => !char.IsDigit(c) ? ("", a.sb.Append(new string(c, int.Parse(a.t))))
                                        : (a.t + c, a.sb))
           .sb.ToString();

        public static void Main(string[] args)
        {
            const string  raw = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";
            const string encoded = "12W1B12W3B24W1B14W";

            WriteLine($"raw = {raw}");
            WriteLine($"encoded = {encoded}");
            WriteLine($"Encode(raw) = encoded = {Encode(raw)}");
            WriteLine($"Decode(encode) = {Decode(encoded)}");
            WriteLine($"Decode(Encode(raw)) = {Decode(Encode(raw)) == raw}");
            ReadLine();
        }
    }
}
