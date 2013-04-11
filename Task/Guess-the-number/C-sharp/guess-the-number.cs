using System;

class GuessTheNumberGame
{
    static void Main()
    {
        bool numberCorrect = false;
        Random randomNumberGenerator = new Random();
        int randomNumber = randomNumberGenerator.Next(1, 10+1);

        Console.WriteLine("I'm thinking of a number between 1 and 10.  Can you guess it?");
        do
        {
            Console.Write("Guess: ");
            int userGuess = int.Parse(Console.ReadLine());

            if (userGuess == randomNumber)
            {
                numberCorrect = true;
                Console.WriteLine("Congrats!!  You guessed right!");
            }
            else
                Console.WriteLine("That's not it.  Guess again.");
        } while (!numberCorrect);
    }
};
