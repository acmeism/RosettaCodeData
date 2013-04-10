using System;
class Program
{
    static void Main()
    {
        int door = 1, inrementer = 0;
        for (int current = 1; current <= 100; current++)
        {
            Console.Write("Door #{0} ", current);
            if (current == door)
            {
                Console.WriteLine("Open");
                inrementer++;
                door += 2 * inrementer + 1;
            }
            else
                Console.WriteLine("Closed");
        }
    }
}
