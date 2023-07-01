using System;

namespace multtbl
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write(" X".PadRight(4));
            for (int i = 1; i <= 12; i++)
                Console.Write(i.ToString("####").PadLeft(4));

            Console.WriteLine();
            Console.Write(" ___");

            for (int i = 1; i <= 12; i++)
                Console.Write(" ___");

            Console.WriteLine();
            for (int row = 1; row <= 12; row++)
            {
                Console.Write(row.ToString("###").PadLeft(3).PadRight(4));
                for (int col = 1; col <= 12; col++)
                {
                    if (row <= col)
                        Console.Write((row * col).ToString("###").PadLeft(4));
                    else
                        Console.Write("".PadLeft(4));
                }

                Console.WriteLine();
            }

            Console.WriteLine();
            Console.ReadLine();
        }
    }
}
