namespace ConsoleApplication1
{
    using System;
    class Program
    {
        static void Main(string[] args)
        {
            //Perform the operation.
            bool[] doors = new bool[100];
            int n = 0;
            int d;
            while ((d = (++n * n)) <= 100)
                doors[d - 1] = true;

            //Perform the presentation.
            for (d = 0; d < doors.Length; d++)
                Console.WriteLine("Door #{0}: {1}", d + 1, doors[d] ? "Open" : "Closed");
            Console.ReadKey(true);
        }
    }
}
