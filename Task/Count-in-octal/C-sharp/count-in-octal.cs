using System;

class Program
{
    static void Main()
    {
        var number = 0;
        do
        {
            Console.WriteLine(Convert.ToString(number, 8));
        } while (++number > 0);
    }
}
