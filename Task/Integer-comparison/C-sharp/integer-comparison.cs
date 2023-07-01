using System;

class Program
{
    static void Main()
    {
        int a = int.Parse(Console.ReadLine());
        int b = int.Parse(Console.ReadLine());
        if (a < b)
            Console.WriteLine("{0} is less than {1}", a, b);
        if (a == b)
            Console.WriteLine("{0} equals {1}", a, b);
        if (a > b)
            Console.WriteLine("{0} is greater than {1}", a, b);
    }
}
