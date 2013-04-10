using System;
class Program
{
    static void Main()
    {
        //To simplify door numbers, uses indexes 1 to 100 (rather than 0 to 99)
        bool[] doors = new bool[101];
        for (int pass = 1; pass <= 100; pass++)
            for (int current = pass; current <= 100; current += pass)
                doors[current] = !doors[current];
        for (int i = 1; i <= 100; i++)
            Console.WriteLine("Door #{0} " + (doors[i] ? "Open" : "Closed"), i);
    }
}
