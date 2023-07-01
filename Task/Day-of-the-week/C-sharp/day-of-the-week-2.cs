using System;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        string[] days = Enumerable.Range(2008, 2121 - 2007)
            .Select(year => new DateTime(year, 12, 25))
            .Where(day => day.DayOfWeek == DayOfWeek.Sunday)
            .Select(day => day.ToString("dd MMM yyyy")).ToArray();

        foreach (string day in days) Console.WriteLine(day);
    }
}
