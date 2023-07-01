using System;
using System.Diagnostics;

class Program
{
    static void Inner()
    {
        Console.WriteLine(new StackTrace());
    }

    static void Middle()
    {
        Inner();
    }

    static void Outer()
    {
        Middle();
    }

    static void Main()
    {
        Outer();
    }
}
