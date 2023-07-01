using System;

namespace _5_Weekends
{
    class Program
    {
        const int FIRST_YEAR = 1900;
        const int LAST_YEAR = 2100;
        static int[] _31_MONTHS = { 1, 3, 5, 7, 8, 10, 12 };

        static void Main(string[] args)
        {
            int totalNum = 0;
            int totalNo5Weekends = 0;

            for (int year = FIRST_YEAR; year <= LAST_YEAR; year++)
            {
                bool has5Weekends = false;

                foreach (int month in _31_MONTHS)
                {
                    DateTime firstDay = new DateTime(year, month, 1);
                    if (firstDay.DayOfWeek == DayOfWeek.Friday)
                    {
                        totalNum++;
                        has5Weekends = true;
                        Console.WriteLine(firstDay.ToString("yyyy - MMMM"));
                    }
                }

                if (!has5Weekends) totalNo5Weekends++;
            }
            Console.WriteLine("Total 5-weekend months between {0} and {1}: {2}", FIRST_YEAR, LAST_YEAR, totalNum);
            Console.WriteLine("Total number of years with no 5-weekend months {0}", totalNo5Weekends);
        }
    }
}
