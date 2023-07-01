using System;
using System.Linq;
using System.Net;

namespace CsvToHtml
{
    class Program
    {
        static void Main(string[] args)
        {
            string csv =
                @"Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!";

            Console.Write(ConvertCsvToHtmlTable(csv, true));
        }

        private static string ConvertCsvToHtmlTable(string csvText, bool formatHeaders)
        {
            var rows =
                (from text in csvText.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries) /* Split the string by newline,
                                                                                                          * removing any empty rows. */
                 select text.Split(',')).ToArray(); // Split each row by comma.

            string output = "<table>"; // Initialize the output with the value of "<table>".

            for (int index = 0; index < rows.Length; index++) // Iterate through each row.
            {
                var row = rows[index];
                var tag = (index == 0 && formatHeaders) ? "th" : "td"; /* Check if this is the first row, and if to format headers.
                                                                        * If so, then set the tags as table headers.
                                                                        * Otherwise, set the tags as table data. */

                output += "\r\n\t<tr>"; // Add table row tag to output string.

                // Add escaped cell data with proper tags to output string for each cell in row.
                output = row.Aggregate(output,
                                       (current, cell) =>
                                       current +
                                       string.Format("\r\n\t\t<{0}>{1}</{0}>", tag, WebUtility.HtmlEncode(cell)));

                output += "\r\n\t</tr>"; // Add closing table row tag to output string.
            }

            output += "\r\n</table>"; // Add closing table tag to output string.

            return output;
        }
    }
}
