using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class Program
{
    static int[] frequBounds = { 4, 8, 12, 16, 25, int.MaxValue };
    static int[] frequ = new int[6];

    public static void Main()
    {
        var data = File.ReadAllLines("data.txt").Select(s => float.Parse(s)).ToArray();

        for (int i = 0; i < data.Count(); i++) {
            int j = i;
            while (j + 1 < data.Count() && data[j] >= data[j + 1])
                j++;

            if (data[i] > data[j]) {
                float percent = 100 * (data[i] - data[j]) / data[i];
                int bin = Array.FindIndex(frequBounds, x => x > percent);
                frequ[bin]++;
            }

            i = j;
        }

        Console.WriteLine("    Bin       Count");
        Console.WriteLine("===================");
        Console.WriteLine("( 0% , 4%) {0,5}", frequ[0]);
        for (int i = 1; i < 5; i++)
            Console.WriteLine("[{0,2}%, {1,2}%) {2,5}", frequBounds[i - 1], frequBounds[i], frequ[i]);
        Console.WriteLine("[25%, inf) {0,5}", frequ[5]);
    }
}
