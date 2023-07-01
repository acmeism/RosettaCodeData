using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Multisplit
{
    internal static class Program
    {
        private static void Main(string[] args)
        {
            foreach (var s in "a!===b=!=c".Multisplit(true, "==", "!=", "=")) // Split the string and return the separators.
            {
                Console.Write(s); // Write the returned substrings and separators to the console.
            }
            Console.WriteLine();
        }

        private static IEnumerable<string> Multisplit(this string s, bool returnSeparators = false,
                                                      params string[] delimiters)
        {
            var currentString = new StringBuilder(); /* Initiate the StringBuilder. This will hold the current string to return
                                                      * once we find a separator. */

            int index = 0; // Initiate the index counter at 0. This tells us our current position in the string to read.

            while (index < s.Length) // Loop through the string.
            {
                // This will get the highest priority separator found at the current index, or null if there are none.
                string foundDelimiter =
                    (from delimiter in delimiters
                     where s.Length >= index + delimiter.Length &&
                           s.Substring(index, delimiter.Length) == delimiter
                     select delimiter).FirstOrDefault();

                if (foundDelimiter != null)
                {
                    yield return currentString.ToString(); // Return the current string.
                    if (returnSeparators) // Return the separator, if the user specified to do so.
                        yield return
                            string.Format("{{\"{0}\", ({1}, {2})}}",
                                          foundDelimiter,
                                          index, index + foundDelimiter.Length);
                    currentString.Clear(); // Clear the current string.
                    index += foundDelimiter.Length; // Move the index past the current separator.
                }
                else
                {
                    currentString.Append(s[index++]); // Add the character at this index to the current string.
                }
            }

            if (currentString.Length > 0)
                yield return currentString.ToString(); // If we have anything left over, return it.
        }
    }
}
