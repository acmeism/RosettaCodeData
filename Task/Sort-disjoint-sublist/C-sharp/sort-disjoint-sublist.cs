using System;
using System.Linq;
using System.Collections.Generic;

public class Test
{
    public static void Main()
    {
        var list = new List<int>{ 7, 6, 5, 4, 3, 2, 1, 0 };
        list.SortSublist(6, 1, 7);
        Console.WriteLine(string.Join(", ", list));
    }
}

public static class Extensions
{
    public static void SortSublist<T>(this List<T> list, params int[] indices)
        where T : IComparable<T>
    {
        var sublist = indices.OrderBy(i => i)
            .Zip(indices.Select(i => list[i]).OrderBy(v => v),
                (Index, Value) => new { Index, Value });

        foreach (var entry in sublist) {
            list[entry.Index] = entry.Value;
        }
    }

}
