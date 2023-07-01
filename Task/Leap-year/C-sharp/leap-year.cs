using System;

class Program
{
    static void Main()
    {
        foreach (var year in new[] { 1900, 1994, 1996, DateTime.Now.Year })
        {
            Console.WriteLine("{0} is {1}a leap year.",
                              year,
                              DateTime.IsLeapYear(year) ? string.Empty : "not ");
        }
    }
}
