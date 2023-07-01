using System;
using System.Collections.Generic;

namespace Roman
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            // Decode and print the numerals.
            Console.WriteLine("{0}: {1}", "MCMXC", Decode("MCMXC"));
            Console.WriteLine("{0}: {1}", "MMVIII", Decode("MMVIII"));
            Console.WriteLine("{0}: {1}", "MDCLXVI", Decode("MDCLXVI"));
        }

        // Dictionary to hold our numerals and their values.
        private static readonly Dictionary<char, int> RomanDictionary = new Dictionary<char, int>
                                                                            {
                                                                                {'I', 1},
                                                                                {'V', 5},
                                                                                {'X', 10},
                                                                                {'L', 50},
                                                                                {'C', 100},
                                                                                {'D', 500},
                                                                                {'M', 1000}
                                                                            };

        private static int Decode(string roman)
        {
            /* Make the input string upper-case,
             * because the dictionary doesn't support lower-case characters. */
            roman = roman.ToUpper();

            /* total = the current total value that will be returned.
             * minus = value to subtract from next numeral. */
            int total = 0, minus = 0;

            for (int i = 0; i < roman.Length; i++) // Iterate through characters.
            {
                // Get the value for the current numeral. Takes subtraction into account.
                int thisNumeral = RomanDictionary[roman[i]] - minus;

                /* Checks if this is the last character in the string, or if the current numeral
                 * is greater than or equal to the next numeral. If so, we will reset our minus
                 * variable and add the current numeral to the total value. Otherwise, we will
                 * subtract the current numeral from the next numeral, and continue. */
                if (i >= roman.Length - 1 ||
                    thisNumeral + minus >= RomanDictionary[roman[i + 1]])
                {
                    total += thisNumeral;
                    minus = 0;
                }
                else
                {
                    minus = thisNumeral;
                }
            }

            return total; // Return the total.
        }
    }
}
