using System;
using System.Collections.Generic;
using System.Linq;

class RangeExtraction
{
    static void Main()
    {
        const string testString = "0,  1,  2,  4,  6,  7,  8, 11, 12, 14,15, 16, 17, 18, 19, 20, 21, 22, 23, 24,25, 27, 28, 29, 30, 31, 32, 33, 35, 36,37, 38, 39";
        var result = String.Join(",", RangesToStrings(GetRanges(testString)));
        Console.Out.WriteLine(result);
    }

    public static IEnumerable<IEnumerable<int>> GetRanges(string testString)
    {
        var numbers = testString.Split(new[] { ',' }).Select(x => Convert.ToInt32(x));
        var current = new List<int>();
        foreach (var n in numbers)
        {
            if (current.Count == 0)
            {
                current.Add(n);
            }
            else
            {
                if (current.Max() + 1 == n)
                {
                    current.Add(n);
                }
                else
                {
                    yield return current;
                    current = new List<int> { n };
                }
            }
        }
        yield return current;
    }

    public static IEnumerable<string> RangesToStrings(IEnumerable<IEnumerable<int>> ranges)
    {
        foreach (var range in ranges)
        {
            if (range.Count() == 1)
            {
                yield return range.Single().ToString();
            }
            else if (range.Count() == 2)
            {
                yield return range.Min() + "," + range.Max();
            }
            else
            {
                yield return range.Min() + "-" + range.Max();
            }
        }
    }
}
