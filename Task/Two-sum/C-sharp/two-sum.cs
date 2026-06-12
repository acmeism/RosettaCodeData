using System;
using System.Collections.Generic;

public class Program
{
    public static void Main(string[] args)
    {
        int[] arr = { 0, 2, 11, 19, 90 };
        const int sum = 21;

        var ts = TwoSum(arr, sum);
        Console.WriteLine(ts != null ? $"{ts[0]}, {ts[1]}" : "no result");

        Console.ReadLine();
    }

    public static int[] TwoSum(int[] numbers, int sum)
    {
        var map = new Dictionary<int, int>();
        for (int i = 0; i < numbers.Length; i++)
        {
            // see if the complement is stored
            var key = sum - numbers[i];
            if (map.ContainsKey(key))
            {
                return new[] { map[key], i };
            }
            map.Add(numbers[i], i);
        }
        return null;
    }
}
