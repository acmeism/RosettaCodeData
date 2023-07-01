using System;

class Program
{
    static void Main(string[] args)
    {
        for (int i = 1; ; i++)
        {
            Console.Write(i);
            if (i == 10) break;
            Console.Write(", ");
        }
        Console.WriteLine();
    }
}
