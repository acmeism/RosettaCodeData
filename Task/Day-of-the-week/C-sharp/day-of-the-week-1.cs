using System;

class Program
{
    static void Main(string[] args)
    {
        for (int i = 2008; i <= 2121; i++)
        {
            DateTime date = new DateTime(i, 12, 25);
            if (date.DayOfWeek == DayOfWeek.Sunday)
            {
                Console.WriteLine(date.ToString("dd MMM yyyy"));
            }
        }
    }
}
