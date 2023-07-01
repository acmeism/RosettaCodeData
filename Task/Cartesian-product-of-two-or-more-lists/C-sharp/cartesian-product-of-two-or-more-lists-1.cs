using System;
public class Program
{
    public static void Main()
    {
        int[] empty = new int[0];
        int[] list1 = { 1, 2 };
        int[] list2 = { 3, 4 };
        int[] list3 = { 1776, 1789 };
        int[] list4 = { 7, 12 };
        int[] list5 = { 4, 14, 23 };
        int[] list6 = { 0, 1 };
        int[] list7 = { 1, 2, 3 };
        int[] list8 = { 30 };
        int[] list9 = { 500, 100 };

        foreach (var sequenceList in new [] {
            new [] { list1, list2 },
            new [] { list2, list1 },
            new [] { list1, empty },
            new [] { empty, list1 },
            new [] { list3, list4, list5, list6 },
            new [] { list7, list8, list9 },
            new [] { list7, empty, list9 }
        }) {
            var cart = sequenceList.CartesianProduct()
                .Select(tuple => $"({string.Join(", ", tuple)})");
            Console.WriteLine($"{{{string.Join(", ", cart)}}}");
        }
    }
}

public static class Extensions
{
    public static IEnumerable<IEnumerable<T>> CartesianProduct<T>(this IEnumerable<IEnumerable<T>> sequences) {
        IEnumerable<IEnumerable<T>> emptyProduct = new[] { Enumerable.Empty<T>() };
        return sequences.Aggregate(
            emptyProduct,
            (accumulator, sequence) =>
            from acc in accumulator
            from item in sequence
            select acc.Concat(new [] { item }));
    }
}
