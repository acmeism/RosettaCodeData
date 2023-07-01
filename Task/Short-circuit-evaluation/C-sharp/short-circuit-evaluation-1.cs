using System;

class Program
{
    static bool a(bool value)
    {
        Console.WriteLine("a");
        return value;
    }

    static bool b(bool value)
    {
        Console.WriteLine("b");
        return value;
    }

    static void Main()
    {
        foreach (var i in new[] { false, true })
        {
            foreach (var j in new[] { false, true })
            {
                Console.WriteLine("{0} and {1} = {2}", i, j, a(i) && b(j));
                Console.WriteLine();
                Console.WriteLine("{0} or {1} = {2}", i, j, a(i) || b(j));
                Console.WriteLine();
            }
        }
    }
}
