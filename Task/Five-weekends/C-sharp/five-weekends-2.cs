using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    public static void Main()
    {
        const int startYear = 1900, endYear = 2100;

        var query = (
            from year in startYear.To(endYear)
            from month in 1.To(12)
            where DateTime.DaysInMonth(year, month) == 31
            select new DateTime(year, month, 1) into date
            where date.DayOfWeek == DayOfWeek.Friday
            select date)
            .ToList();

        Console.WriteLine("Count: " + query.Count);
        Console.WriteLine();
        Console.WriteLine("First and last 5:");
        for (int i = 0; i < 5; i++)
            Console.WriteLine(query[i].ToString("MMMM yyyy"));
        Console.WriteLine("...");
        for (int i = query.Count - 5; i < query.Count; i++)
            Console.WriteLine(query[i].ToString("MMMM yyyy"));
        Console.WriteLine();
        Console.WriteLine("Years without 5 weekends:");
        Console.WriteLine(string.Join(" ", startYear.To(endYear).Except(query.Select(dt => dt.Year))));
    }
}

public static class IntExtensions
{
    public static IEnumerable<int> To(this int start, int end) => Enumerable.Range(start, end - start + 1);
}
