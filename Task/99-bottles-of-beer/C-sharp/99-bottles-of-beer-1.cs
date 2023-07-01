using System;

class Program
{
    static void Main(string[] args)
    {
        for (int i = 99; i > -1; i--)
        {
            if (i == 0)
            {
                Console.WriteLine("No more bottles of beer on the wall, no more bottles of beer.");
                Console.WriteLine("Go to the store and buy some more, 99 bottles of beer on the wall.");
                break;
            }
            if (i == 1)
            {
                Console.WriteLine("1 bottle of beer on the wall, 1 bottle of beer.");
                Console.WriteLine("Take one down and pass it around, no more bottles of beer on the wall.");
                Console.WriteLine();
            }
            else
            {
                Console.WriteLine("{0} bottles of beer on the wall, {0} bottles of beer.", i);
                Console.WriteLine("Take one down and pass it around, {0} bottles of beer on the wall.", i - 1);
                Console.WriteLine();
            }
        }
    }
}
