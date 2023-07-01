using System;

namespace LastSundayOfEachMonth
{
    class Program
    {
        static void Main()
        {
            Console.Write("Year to calculate: ");

            string strYear = Console.ReadLine();
            int year = Convert.ToInt32(strYear);

            DateTime date;
            for (int i = 1; i <= 12; i++)
            {
                date = new DateTime(year, i, DateTime.DaysInMonth(year, i), System.Globalization.CultureInfo.CurrentCulture.Calendar);
                /* Modification by Albert Zakhia on 2021-16-02
                   The below code is very slow due to the loop, we will go twice as fast
                while (date.DayOfWeek != DayOfWeek.Sunday)
                {
                    date = date.AddDays(-1);
                }
                */
                // The updated code
                int daysOffset = date.DayOfWeek - dayOfWeek; // take the offset to subtract directly instead of looping
                if (daysOffset < 0) daysOffset += 7; // if the code is negative, we need to normalize them
                date = date.AddDays(-daysOffset ); // now just add the days offset
                Console.WriteLine(date.ToString("yyyy-MM-dd"));
            }
        }
    }
}
