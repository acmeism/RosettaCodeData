using System;

class Program
{
    static void Main(string[] args)
    {
        double average = 0;

        double[] numArray = { 1, 2, 3, 4, 5 };
        average = Average(numArray);

        Console.WriteLine(average); // Output is 3

        // Alternative use
        average = Average(1, 2, 3, 4, 5);

        Console.WriteLine(average); // Output is still 3
        Console.ReadLine();
    }

    static double Average(params double[] nums)
    {
        double d = 0;

        foreach (double num in nums)
            d += num;
        return d / nums.Length;
    }
}
