using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    string s = @"gHHH5YY++///\";
    Console.WriteLine(s.RunLengthSplit().Delimit(", "));
}

public static class Extensions
{
    public static IEnumerable<string> RunLengthSplit(this string source) {
        using (var enumerator = source.GetEnumerator()) {
            if (!enumerator.MoveNext()) yield break;
            char previous = enumerator.Current;
            int count = 1;
            while (enumerator.MoveNext()) {
                if (previous == enumerator.Current) {
                    count++;
                } else {
                    yield return new string(Enumerable.Repeat(previous, count).ToArray());
                    previous = enumerator.Current;
                    count = 1;
                }
            }
            yield return new string(Enumerable.Repeat(previous, count).ToArray());
        }
    }

    public static string Delimit<T>(this IEnumerable<T> source, string separator = "") => string.Join(separator ?? "", source);
}
