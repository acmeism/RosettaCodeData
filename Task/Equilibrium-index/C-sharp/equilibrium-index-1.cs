using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static IEnumerable<int> EquilibriumIndices(IEnumerable<int> sequence)
    {
        var left = 0;
        var right = sequence.Sum();
        var index = 0;
        foreach (var element in sequence)
        {
            right -= element;
            if (left == right)
            {
                yield return index;
            }
            left += element;
            index++;
        }
    }

    static void Main()
    {
        foreach (var index in EquilibriumIndices(new[] { -7, 1, 5, 2, -4, 3, 0 }))
        {
            Console.WriteLine(index);
        }
    }
}
