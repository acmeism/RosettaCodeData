using System;
using System.Collections.Generic;
using System.Linq;

class ReturnMultipleValues
{
    static void Main()
    {
        var values = new[] { 4, 51, 1, -3, 3, 6, 8, 26, 2, 4 };
        int max, min;
        MinMaxNum(values, out max, out min);

        Console.WriteLine("Min: {0}\nMax: {1}", min, max);
    }

    static void MinMaxNum(IEnumerable<int> nums, out int max, out int min)
    {
        var sortedNums = nums.OrderBy(num => num).ToArray();
        max = sortedNums.Last();
        min = sortedNums.First();
    }
}
