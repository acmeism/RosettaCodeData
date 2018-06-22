namespace ConsoleApplication1
{
    using System;
    class Program
    {
        static void Main()
        {
            //The o variable stores the number of the next OPEN door.
            int o = 1;
            int f = 1;
            int l = 5;
            Random r = new Random();
            o = r.Next(f, l);

            //The d variable determines the door to be output next.
            for (int d = 1; d <= 100; d++)
            {
                Console.Write("Door #{0}: ", d);
                if (d == o)
                {
                    Console.WriteLine("Open");
                    f = f + 5;
                    l = l + 5;
                    o = r.Next(f, l);
                }
                else
                    Console.WriteLine("Closed");
            }
            Console.ReadKey(true);
        }
    }
}
