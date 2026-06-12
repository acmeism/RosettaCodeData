using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("25th of December 2021 is a " + new DateTime(2021, 12, 25).DayOfWeek);
        Console.WriteLine("1st of January 2022 is a " + new DateTime(2022, 1, 1).DayOfWeek);
    }
}
