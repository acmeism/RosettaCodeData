namespace ConsoleApplication1
{
    using System;
    class Program
    {
        static void Main()
        {
            bool[] doors = new bool[100];

            //The number of passes can be 1-based, but the number of doors must be 0-based.
            for (int p = 1; p <= 100; p++)
                for (int d = p - 1; d < 100; d += p)
                    doors[d] = !doors[d];
            for (int d = 0; d < 100; d++)
                Console.WriteLine("Door #{0}: {1}", d + 1, doors[d] ? "Open" : "Closed");
            Console.ReadKey(true);
        }
    }
}
