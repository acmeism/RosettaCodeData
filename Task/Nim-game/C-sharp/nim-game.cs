using System;

namespace nimGame
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("There are twelve tokens.\n" +
                    "You can take 1, 2, or 3 on your turn.\n" +
                    "Whoever takes the last token wins.\n");

            int tokens = 12;

            while (tokens > 0)
            {
                Console.WriteLine("There are " + tokens + " remaining.");
                Console.WriteLine("How many do you take?");
                int playertake = Convert.ToInt32(Console.ReadLine());

                if (playertake < 1 | playertake > 3)
                {
                    Console.WriteLine("1, 2, or 3 only.");
                }
                else
                {
                    tokens -= playertake;
                    Console.WriteLine("I take " + (4 - playertake) + ".");
                    tokens -= (4 - playertake);
                }
            }
            Console.WriteLine("I win again.");
            Console.ReadLine();
        }

    }
}
