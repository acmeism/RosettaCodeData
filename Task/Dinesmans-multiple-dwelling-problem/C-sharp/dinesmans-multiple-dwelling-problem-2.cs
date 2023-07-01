using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

static class Program
{
    enum Tenants { Baker = 0, Cooper = 1, Fletcher = 2, Miller = 3, Smith = 4 };

    static void Main()
    {
        var count = Enum.GetNames(typeof(Tenants)).Length;
        var top = count - 1;

        var solve =
            from f in Range(0, count).Permutations()
            let floors = f.ToArray()
            where floors[(int)Tenants.Baker] != top //r1
            where floors[(int)Tenants.Cooper] != 0 //r2
            where floors[(int)Tenants.Fletcher] != top && floors[(int)Tenants.Fletcher] != 0 //r3
            where floors[(int)Tenants.Miller] > floors[(int)Tenants.Cooper] //r4
            where Math.Abs(floors[(int)Tenants.Smith] - floors[(int)Tenants.Fletcher]) !=1 //r5
            where Math.Abs(floors[(int)Tenants.Fletcher] - floors[(int)Tenants.Cooper]) !=1 //r6
            select floors;
        var solved = solve.First();
        var output = Range(0,count).OrderBy(i=>solved[i]).Select(f => ((Tenants)f).ToString());
        Console.WriteLine(String.Join(" ", output));
        Console.Read();
    }

    public static IEnumerable<IEnumerable<T>> Permutations<T>(this IEnumerable<T> values)
    {
        if (values.Count() == 1)
            return values.ToSingleton();

        return values.SelectMany(v => Permutations(values.Except(v.ToSingleton())), (v, p) => p.Prepend(v));
    }

    public static IEnumerable<T> ToSingleton<T>(this T item) { yield return item; }
}
