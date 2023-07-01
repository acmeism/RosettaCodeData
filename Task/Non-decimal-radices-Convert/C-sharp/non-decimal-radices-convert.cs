public static class BaseConverter {

    /// <summary>
    /// Converts a string to a number
    /// </summary>
    /// <returns>The number.</returns>
    /// <param name="s">The string to convert.</param>
    /// <param name="b">The base number (between 2 and 36).</param>
    public static long stringToLong(string s, int b) {

        if ( b < 2 || b > 36 )
            throw new ArgumentException("Base must be between 2 and 36", "b");

        checked {

            int slen = s.Length;
            long result = 0;
            bool isNegative = false;

            for ( int i = 0; i < slen; i++ ) {

                char c = s[i];
                int num;

                if ( c == '-' ) {
                    // Negative sign
                    if ( i != 0 )
                        throw new ArgumentException("A negative sign is allowed only as the first character of the string.", "s");

                    isNegative = true;
                    continue;
                }

                if ( c > 0x2F && c < 0x3A )
                    // Numeric character (subtract from 0x30 ('0') to get numerical value)
                    num = c - 0x30;
                else if ( c > 0x40 && c < 0x5B )
                    // Uppercase letter
                    // Subtract from 0x41 ('A'), then add 10
                    num = c - 0x37;  // 0x37 = 0x41 - 10
                else if ( c > 0x60 && c < 0x7B )
                    // Lowercase letter
                    // Subtract from 0x61 ('a'), then add 10
                    num = c - 0x57;  // 0x57 = 0x61 - 10
                else
                    throw new ArgumentException("The string contains an invalid character '" + c + "'", "s");

                // Check that the digit is allowed by the base.

                if ( num >= b )
                    throw new ArgumentException("The string contains a character '" + c + "' which is not allowed in base " + b, "s");

                // Multiply the result by the base, then add the next digit

                result *= b;
                result += num;

            }

            if ( isNegative )
                result = -result;

            return result;

        }

    }

    /// <summary>
    /// Converts a number to a string.
    /// </summary>
    /// <returns>The string.</returns>
    /// <param name="n">The number to convert.</param>
    /// <param name="b">The base number (between 2 and 36).</param>
    public static string longToString(long n, int b) {

        // This uses StringBuilder, so it only works with .NET 4.0 or higher. For earlier versions, the StringBuilder
        // can be replaced with simple string concatenation.

        if ( b < 2 || b > 36 )
            throw new ArgumentException("Base must be between 2 and 36", "b");

        // If the base is 10, call ToString() directly, which returns a base-10 string.

        if ( b == 10 )
            return n.ToString();

        checked {
            long longBase = b;

            StringBuilder sb = new StringBuilder();

            if ( n < 0 ) {
                // Negative numbers
                n = -n;
                sb.Append('-');
            }

            long div = 1;
            while ( n / div >= b )
                // Continue multiplying the dividend by the base until it reaches the greatest power of
                // the base which is less than or equal to the number.
                div *= b;

            while ( true ) {
                byte digit = (byte) (n / div);

                if ( digit < 10 )
                    // Numeric character (0x30 = '0')
                    sb.Append((char) (digit + 0x30));
                else
                    // Alphabetic character (for digits > 10) (0x61 = 'a')
                    sb.Append((char) (digit + 0x57));  // 0x61 - 10

                if ( div == 1 )
                    // Stop when the dividend reaches 1
                    break;

                n %= div;
                div /= b;
            }

            return sb.ToString();
        }

    }

}
