namespace ConsoleApplication1
{
    using System;
    class Program
    {
        static void Main()
        {
            //The o variable stores the number of the next OPEN door.
            int o = 1;

            //The n variable is used to help calculate the next value of the o variable.
            int n = 0;

            //The d variable determines the door to be output next.
            for (int d = 1; d <= 100; d++)
            {
                Console.Write("Door #{0}: ", d);
                if (d == o)
                {
                    Console.WriteLine("Open");
                    n++;
                    o += 2 * n + 1;
                }
                else
                    Console.WriteLine("Closed");
            }
            Console.ReadKey(true);
        }
    }
}
