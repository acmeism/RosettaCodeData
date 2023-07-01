using System;
using System.Collections.Generic;
using System.Linq;

static class PartialApplicationDynamic
{
    // Create a matching delegate type to simplify delegate creation.
    delegate IEnumerable<TResult> fsDelegate<TSource, TResult>(Func<TSource, TResult> f, IEnumerable<TSource> s);

    static IEnumerable<TResult> fs<TSource, TResult>(Func<TSource, TResult> f, IEnumerable<TSource> s) => s.Select(f);

    static dynamic f1(dynamic x) => x * 2;

    static dynamic f2(dynamic x) => x * x;

    static T[] ArrayConcat<T>(T[] arr1, T[] arr2)
    {
        var result = new T[arr1.Length + arr2.Length];
        Array.Copy(arr1, result, arr1.Length);
        Array.Copy(arr2, 0, result, 1, arr2.Length);
        return result;
    }

    // Use a specialized params delegate to simplify calling at the risk of inadvertent params expansion.
    delegate TResult partialDelegate<TParams, TResult>(params TParams[] args);
    static partialDelegate<dynamic, TResult> PartialApplyDynamic<TDelegate, TResult>(TDelegate f, params dynamic[] args) where TDelegate : Delegate
    {
        return rest => (TResult)f.DynamicInvoke(ArrayConcat(args, rest).Cast<dynamic>().ToArray());
    }

    static void Main()
    {
        // Cast to object to avoid params expansion of the arrays.
        object args1 = new object[] { 0, 1, 2, 3 };
        object args2 = new object[] { 2, 4, 6, 8 };

        var fsf1 = PartialApplyDynamic<fsDelegate<dynamic, dynamic>, IEnumerable<dynamic>>(fs, new Func<dynamic, dynamic>(f1));
        var fsf2 = PartialApplyDynamic<fsDelegate<dynamic, dynamic>, IEnumerable<dynamic>>(fs, new Func<dynamic, dynamic>(f2));

        Console.WriteLine("fsf1, 0-3: " + string.Join(", ", fsf1(args1)));
        Console.WriteLine("fsf1, evens: " + string.Join(", ", fsf1(args2)));
        Console.WriteLine("fsf2, 0-3: " + string.Join(", ", fsf2(args1)));
        Console.WriteLine("fsf2, evens: " + string.Join(", ", fsf2(args2)));
    }
}
