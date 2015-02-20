using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading; //Remember to add this if you want the game to pause in RealisticGuess.Start()

namespace ConsoleApplication1
{
    class RealisticGuess //Simulates a guessing game between two people. Guessing efficiency is not a goal.
    {
        private int max;
        private int min;
        private int guess;

        public void Start()
        {
            Console.Clear();
            string input;

            try
            {
                Console.WriteLine("Please enter the lower boundary");
                input = Console.ReadLine();
                min = Convert.ToInt32(input);
                Console.WriteLine("Please enter the upper boundary");
                input = Console.ReadLine();
                max = Convert.ToInt32(input);
            }
            catch (FormatException)
            {
                Console.WriteLine("The entry you have made is invalid. Please make sure your entry is an integer and try again.");
                Console.ReadKey(true);
                Start();
            }
            Console.WriteLine("Think of a number between {0} and {1}.", min, max);
            Thread.Sleep(2500);
            Console.WriteLine("Ready?");
            Console.WriteLine("Press any key to begin.");
            Console.ReadKey(true);
            Guess(min, max);
        }
        public void Guess(int min, int max)
        {
            int counter = 1;
            string userAnswer;
            bool correct = false;
            Random rand = new Random();

            while (correct == false)
            {
                guess = rand.Next(min, max);
                Console.Clear();
                Console.WriteLine("{0}", guess);
                Console.WriteLine("Is this number correct? {Y/N}");
                userAnswer = Console.ReadLine();
                if (userAnswer != "y" && userAnswer != "Y" && userAnswer != "n" && userAnswer != "N")
                {
                    Console.WriteLine("Your entry is invalid. Please enter either 'Y' or 'N'");
                    Console.WriteLine("Is the number correct? {Y/N}");
                    userAnswer = Console.ReadLine();
                }
                if (userAnswer == "y" || userAnswer == "Y")
                {
                    correct = true;
                }
                if (userAnswer == "n" || userAnswer == "N")
                {
                    counter++;
                    if (max == min)
                    {
                        Console.WriteLine("Error: Range Intersect. Press enter to restart the game.");  //This message should never pop up if the user enters good data.
                        Console.ReadKey(true);                                                          //It handles the game-breaking exception that occurs
                        Guess(1, 101);                                                                  //when the max guess number is the same as the min number.
                    }
                    Console.WriteLine("Is the number you're thinking of lower or higher? {L/H}");
                    userAnswer = Console.ReadLine();
                    if (userAnswer != "l" && userAnswer != "L" && userAnswer != "h" && userAnswer != "H")
                    {
                        Console.WriteLine("Your entry is invalid. Please enter either 'L' or 'H'");
                        Console.WriteLine("Is the number you're thinking of lower or higher? {L/H}");
                        userAnswer = Console.ReadLine();
                    }
                    if (userAnswer == "l" || userAnswer == "L")
                    {
                        max = guess;
                    }
                    if (userAnswer == "h" || userAnswer == "H")
                    {
                        min = guess;
                    }
                }
            }
            if (correct == true)
            {
                EndAndLoop(counter);
            }
        }

        public void EndAndLoop(int iterations)
        {
            string userChoice;
            bool loop = false;
            Console.WriteLine("Game over. It took {0} guesses to find the number.", iterations);
            while (loop == false)
            {
                Console.WriteLine("Would you like to play again? {Y/N}");
                userChoice = Console.ReadLine();
                if (userChoice != "Y" && userChoice != "y" && userChoice != "N" && userChoice != "n")
                {
                    Console.WriteLine("Sorry, your input is invalid. Please answer 'Y' to play again, or 'N' to quit.");
                }
                if (userChoice == "Y" || userChoice == "y")
                {
                    Start();
                }
                if (userChoice == "N" || userChoice == "n")
                {
                    Environment.Exit(1);
                }
            }
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            Console.Title = "Random Number";
            RealisticGuess game = new RealisticGuess();
            game.Start();
        }
    }
}
