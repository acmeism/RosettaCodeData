using System;
using System.Collections.Generic;
using System.Linq;

namespace RangeExpansion {
  internal static class StringExtensions {
    internal static IEnumerable<int> ExpandRange(this string s) {
      return s.Split(',')
        .Select(rstr => {
          int start;
          if (int.TryParse(rstr, out start))
            return new {Start = start, End = start};
          var istr = new string(("+-".Any(_ => rstr[0] == _)
            ? rstr.Take(1).Concat(rstr.Skip(1).TakeWhile(char.IsDigit))
            : rstr.TakeWhile(char.IsDigit)
            ).ToArray());
          rstr = rstr.Substring(istr.Length + 1, (rstr.Length - istr.Length) - 1);
          return new {Start = int.Parse(istr), End = int.Parse(rstr)};
        }).SelectMany(_ => Enumerable.Range(_.Start, _.End - _.Start + 1));
    }
  }

  internal static class Program {
    private static void Main() {
      const string RANGE_STRING = "-6,-3--1,3-5,7-11,14,15,17-20";
      var values = RANGE_STRING.ExpandRange().ToList();
      var vstr = string.Join(", ", values.Select(_ => _.ToString()));
      Console.WriteLine(vstr);
    }
  }
}
