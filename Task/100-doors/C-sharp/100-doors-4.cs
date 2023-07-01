namespace ConsoleApplication1
{
    using System;
    class Program
    {
        static void Main()
        {
            double n;

            //If the current door number is the perfect square of an integer, say it is open, else say it is closed.
            for (int d = 1; d <= 100; d++)
                Console.WriteLine("Door #{0}: {1}", d, (n = Math.Sqrt(d)) == (int)n ? "Open" : "Closed");
            Console.ReadKey(true);
        }
    }
}
