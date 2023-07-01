using System;

class Program
{
    static void Main()
    {
        foreach (var number in new[] { 5, 50, 9000 })
        {
            Console.WriteLine(Convert.ToString(number, 2));
        }
    }
}
