using System;
using System.Collections.Generic;

public class KaprekarNumbers {

    /// <summary>
    /// The entry point of the program, where the program control starts and ends.
    /// </summary>
    public static void Main() {
        int count = 0;

        foreach ( ulong i in _kaprekarGenerator(999999) ) {
            Console.WriteLine(i);
            count++;
        }

        Console.WriteLine("There are {0} Kaprekar numbers less than 1000000.", count);
    }

    /// <summary>
    /// Generator function which generates the Kaprekar numbers.
    /// </summary>
    /// <returns>The generator.</returns>
    /// <param name="max">The maximum value of the numbers generated.</param>
    private static IEnumerable<ulong> _kaprekarGenerator(ulong max) {

        ulong next = 1;

        // 1 is always a Kaprekar number.
        yield return next;

        for ( next = 2; next <= max; next++ ) {

            ulong square = next * next;

            for ( ulong check = 10; check <= 10000000000000000000; check *= 10 ) {
                // Check the square against each power of 10 from 10^1 to 10^19 (highest which can be
                // represented by a ulong)

                // If the power of 10 to be checked against is greater than or equal to the square, stop checking
                if ( square <= check )
                    break;

                // Given a power of 10 as 10^n, the remainder when dividing the square number by that power
                // of 10 is equal to the last n digits of the number (starting from the right) and the
                // quotient gives the remaining digits.
                // If the last n digits are all zeroes, then the remainder will be zero, which is not
                // accepted.

                ulong r = square % check;
                ulong q = (square - r) / check;

                if ( r != 0 && q + r == next ) {
                    yield return next;
                    break;
                }
            }

        }

    }

}
