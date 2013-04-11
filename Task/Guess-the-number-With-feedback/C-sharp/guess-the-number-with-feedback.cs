using System;

class Program
{
    static void Main(string[] args)
    {
        const int from = 1;
        const int to = 10;

        int randomNumber = new Random().Next(from, to);
        int guessedNumber;

        Console.Write("The number is between {0} and {1}. ", from, to);
        while (true)
        {
            Console.Write("Make a guess: ");
            if (int.TryParse(Console.ReadLine(), out guessedNumber))
            {
                if (guessedNumber == randomNumber)
                {
                    Console.WriteLine("You guessed the right number!");
                    break;
                }
                else
                {
                    Console.WriteLine("Your guess was too {0}.", (guessedNumber > randomNumber) ? "high" : "low");
                }
            }
            else
            {
                Console.WriteLine("Input was not an integer.");
            }
        }

        Console.WriteLine();
        Console.WriteLine("Press any key to exit.");
        Console.ReadKey();
    }
}
