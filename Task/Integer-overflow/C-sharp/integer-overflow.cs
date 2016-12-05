using System;

public class IntegerOverflow
{
    public static void Main() {
        unchecked {
            Console.WriteLine("For 32-bit signed integers:");
            Console.WriteLine(-(-2147483647 - 1));
            Console.WriteLine(2000000000 + 2000000000);
            Console.WriteLine(-2147483647 - 2147483647);
            Console.WriteLine(46341 * 46341);
            Console.WriteLine((-2147483647 - 1) / -1);
            Console.WriteLine();

            Console.WriteLine("For 64-bit signed integers:");
            Console.WriteLine(-(-9223372036854775807L - 1));
            Console.WriteLine(5000000000000000000L + 5000000000000000000L);
            Console.WriteLine(-9223372036854775807L - 9223372036854775807L);
            Console.WriteLine(3037000500L * 3037000500L);
            Console.WriteLine((-9223372036854775807L - 1) / -1);
            Console.WriteLine();

            Console.WriteLine("For 32-bit unsigned integers:");
            //Negating a 32-bit unsigned integer will convert it to a signed 64-bit integer.
            Console.WriteLine(-4294967295U);
            Console.WriteLine(3000000000U + 3000000000U);
            Console.WriteLine(2147483647U - 4294967295U);
            Console.WriteLine(65537U * 65537U);
            Console.WriteLine();

            Console.WriteLine("For 64-bit unsigned integers:");
            // The - operator cannot be applied to 64-bit unsigned integers; it will always give a compile-time error.
            //Console.WriteLine(-18446744073709551615UL);
            Console.WriteLine(10000000000000000000UL + 10000000000000000000UL);
            Console.WriteLine(9223372036854775807UL - 18446744073709551615UL);
            Console.WriteLine(4294967296UL * 4294967296UL);
            Console.WriteLine();
        }

        int i = 2147483647;
        Console.WriteLine(i + 1);
        try {
            checked { Console.WriteLine(i + 1); }
        } catch (OverflowException) {
            Console.WriteLine("Overflow!");
        }
    }

}
