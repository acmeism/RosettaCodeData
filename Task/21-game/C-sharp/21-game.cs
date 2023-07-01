// 21 Game

using System;

namespace _21Game
{
    public class Program
    {
        private const string computerPlayer = "Computer";
        private const string humanPlayer = "Player 1";

        public static string SwapPlayer(string currentPlayer)
        {
            if (currentPlayer == computerPlayer)
            {
                currentPlayer = humanPlayer;
            }
            else
            {
                currentPlayer = computerPlayer;
            }

            return currentPlayer;
        }

        public static void PlayGame()
        {
            bool playAnother = true;
            int total = 0;
            int final = 21;
            int roundChoice = 0;
            string currentPlayer = RandomPLayerSelect();
            int compWins = 0;
            int humanWins = 0;

            while (playAnother)
            {
                Console.WriteLine($"Now playing: {currentPlayer}");
                try
                {
                    if (currentPlayer == computerPlayer)
                    {
                       roundChoice =  CompMove(total);
                    }
                    else
                    {
                        roundChoice = int.Parse(Console.ReadLine());
                    }


                    if (roundChoice != 1 && roundChoice != 2 && roundChoice != 3)
                    {
                        throw new Exception();
                    }

                    total += roundChoice;
                }
                catch (Exception)
                {
                    Console.WriteLine("Invalid choice! Choose from numbers: 1, 2, 3.");
                    continue;
                }

                Console.WriteLine(total);

                if (total == final)
                {
                    if (currentPlayer == computerPlayer)
                    {
                        compWins++;
                    }
                    if (currentPlayer == humanPlayer)
                    {
                        humanWins++;
                    }
                    Console.WriteLine($"Winner: {currentPlayer}");
                    Console.WriteLine($"Comp wins: {compWins}. Human wins: {humanWins}");
                    Console.WriteLine($"do you wan to play another round? y/n");
                    var choice = Console.ReadLine();
                    if (choice == "y")
                    {
                        total = 0;
                    }
                    else if (choice == "n")
                    {
                        break;
                    }
                    else
                    {
                        Console.WriteLine("Invalid choice! Choose from y or n");
                        continue;
                    }
                }

                else if (total > 21)
                {
                    Console.WriteLine("Not the right time to play this game :)");
                    break;
                }

                currentPlayer = SwapPlayer(currentPlayer);
            }
        }

        public static bool CheckIfCanWin(int total)
        {
            bool result = false;
            if (total == 18)
            {
                result = true;
            }
            return result;
        }

        public static int CompMove(int total)
        {
            int choice = 0;

            if (CheckIfCanWin(total))
            {
                choice = 21 - total;
            }
            else
            {
                choice = new Random().Next(1,4);
            }

            return choice;
        }

        public static string RandomPLayerSelect()
        {
            string[] players = new string[] { computerPlayer, humanPlayer };
            var random = new Random().Next(0,2);
            return players[random];
        }

        public static void Main(string[] args)
        {
            // welcome message and rules
            Console.WriteLine("Welcome to 21 game \n");
            Console.WriteLine(@"21 is a two player game.
The game is played by choosing a number.
1, 2, or 3 to be added a total sum. \n
The game is won by the player reaches exactly 21. \n" );
            Console.WriteLine("Choose your number: (1, 2 or 3)");

            PlayGame();
        }
    }
}
