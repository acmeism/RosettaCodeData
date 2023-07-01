using System;

namespace Y_or_N
{
    class Program
    {
        static void Main()
        {
            bool response = GetYorN();
        }

        static bool GetYorN()
        {
            ConsoleKey response; // Creates a variable to hold the user's response.

            do
            {
                while (Console.KeyAvailable) // Flushes the input queue.
                    Console.ReadKey();

                Console.Write("Y or N? "); // Asks the user to answer with 'Y' or 'N'.
                response = Console.ReadKey().Key; // Gets the user's response.
                Console.WriteLine(); // Breaks the line.
            } while (response != ConsoleKey.Y && response != ConsoleKey.N); // If the user did not respond with a 'Y' or an 'N', repeat the loop.

             /*
              * Return true if the user responded with 'Y', otherwise false.
              *
              * We know the response was either 'Y' or 'N', so we can assume
              * the response is 'N' if it is not 'Y'.
              */
            return response == ConsoleKey.Y;
        }
    }
}
