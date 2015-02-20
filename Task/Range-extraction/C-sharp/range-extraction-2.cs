using System;
using System.Collections.Generic;
using System.Linq;

namespace RangeExtraction {
  internal static class ListExtensions {
    internal static string ExtractRange(this IEnumerable<int> values) {
      var list = values.Distinct().OrderBy(_ => _).ToArray();
      var ranges = new int[0][].AsEnumerable();
      var current = 0;
      for (var i = 1; ; ++i) {
        if (i >= list.Length) {
          ranges = ranges.Concat(new[] { new[] { i != current ? current : i - 1, i - 1 } });
          break;
        }
        if (list[i] == list[i - 1] + 1)
          continue;
        ranges = ranges.Concat(new[] { new[] { current, i - 1 } });
        current = i;
      }
      return string.Join(",", ranges.Select(r => string.Format(r[0] == r[1] ? "{0}" : "{0}-{1}", list[r[0]], list[r[1]])));
    }
  }

  internal class Program {
    private static readonly IList<int> VALUES = new[] {
      0, 1, 2,
      4,
      6, 7, 8,
      11, 12,
      14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
      27, 28, 29, 30, 31, 32, 33,
      35, 36, 37, 38, 39
    };

    private static void Main(string[] args) {
      var rangestr = VALUES.ExtractRange();
      Console.WriteLine("values: {{{0}}}", string.Join(", ", VALUES.Select(_=>_.ToString())));
      Console.WriteLine("\r\nranges = \"{0}\"", rangestr);
    }
  }
}
