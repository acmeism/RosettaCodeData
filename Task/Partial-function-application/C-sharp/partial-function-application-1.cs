using System;
using System.Collections.Generic;
using System.Linq;

class PartialFunctionApplication
{
    static Func<T1, TResult> PartiallyApply<T1, T2, TResult>(Func<T1, T2, TResult> function, T2 argument2)
    {
        return argument1 => function(argument1, argument2);
    }

    static void Main()
    {
        var fs = (Func<IEnumerable<int>, Func<int, int>, IEnumerable<int>>)Enumerable.Select;
        var f1 = (Func<int, int>)(n => n * 2);
        var f2 = (Func<int, int>)(n => n * n);
        var fsf1 = PartiallyApply(fs, f1);
        var fsf2 = PartiallyApply(fs, f2);

        var s = new[] { 0, 1, 2, 3 };
        Console.WriteLine(string.Join(", ", fsf1(s)));
        Console.WriteLine(string.Join(", ", fsf2(s)));

        s = new[] { 2, 4, 6, 8 };
        Console.WriteLine(string.Join(", ", fsf1(s)));
        Console.WriteLine(string.Join(", ", fsf2(s)));
    }
}
