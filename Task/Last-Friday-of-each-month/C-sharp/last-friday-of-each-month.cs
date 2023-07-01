using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace RosettaCode.LastFridaysOfYear
{
    internal static class Program
    {
        private static IEnumerable<DateTime> LastFridaysOfYear(int year)
        {
            for (var month = 1; month <= 12; month++)
            {
                var date = new DateTime(year, month, 1).AddMonths(1).AddDays(-1);
                while (date.DayOfWeek != DayOfWeek.Friday)
                {
                    date = date.AddDays(-1);
                }
                yield return date;
            }
        }

        private static void Main(string[] arguments)
        {
            int year;
            var argument = arguments.FirstOrDefault();
            if (string.IsNullOrEmpty(argument) || !int.TryParse(argument, out year))
            {
                year = DateTime.Today.Year;
            }

            foreach (var date in LastFridaysOfYear(year))
            {
                Console.WriteLine(date.ToString("d", CultureInfo.InvariantCulture));
            }
        }
    }
}
