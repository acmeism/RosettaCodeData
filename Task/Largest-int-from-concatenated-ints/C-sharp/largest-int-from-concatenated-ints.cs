using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        var source1 = new int[] { 1, 34, 3, 98, 9, 76, 45, 4 };
        var source2 = new int[] { 54, 546, 548, 60 };

        var largest1 = LargestPossibleSequence(source1);
        var largest2 = LargestPossibleSequence(source2);

        Console.WriteLine("The largest possible integer from set 1 is: {0}", largest1);
        Console.WriteLine("The largest possible integer from set 2 is: {0}", largest2);
    }

    static long LargestPossibleSequence(int[] ints)
    {
        return long.Parse(string.Join("", ints.OrderBy(i => i, new IntConcatenationComparer()).Reverse()));
    }
}

class IntConcatenationComparer : IComparer<int>
{
    public int Compare(int x, int y)
    {
        var xy = int.Parse(x.ToString() + y.ToString());
        var yx = int.Parse(y.ToString() + x.ToString());

        return xy - yx;
    }
}
