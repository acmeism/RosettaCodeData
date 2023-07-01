using System;
using System.Collections.Generic;
using System.Linq;

public class RangeExtraction
{
    public static void Main()
    {
        string s = "0,1,2,4,6,7,8,11,12,14,15, 16, 17, 18, 19, 20, 21, 22, 23, 24,25, 27, 28, 29, 30, 31, 32, 33, 35, 36,37, 38, 39";
        Console.WriteLine(string.Join(",", Ranges(s.Split(',').Select(int.Parse))
            .Select(r => r.end == r.start ? $"{r.start}" : $"{r.start}-{r.end}")));
    }

    static IEnumerable<(int start, int end)> Ranges(IEnumerable<int> numbers) {
        if (numbers == null) yield break;
        var e = numbers.GetEnumerator();
        if (!e.MoveNext()) yield break;

        int start = e.Current;
        int end = start;
        while (e.MoveNext()) {
            if (e.Current - end != 1) {
                if (end - start == 1) {
                    yield return (start, start);
                    yield return (end, end);
                } else {
                    yield return (start, end);
                }
                start = e.Current;
            }
            end = e.Current;
        }
        yield return (start, end);
    }

}
