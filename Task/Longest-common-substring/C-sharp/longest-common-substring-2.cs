//C# program tests the LCSUBSTR (Longest Common Substring) subroutine.
using System;
namespace LongestCommonSubstring
{
    class Program
    {
        static void Main(string[] args)
        {
            string a = args.Length >= 1 ? args[0] : "";                                             /*get two arguments (strings).   */
            string b = args.Length == 2 ? args[1] : "";
            if (a == "") a = "thisisatest";                                                         /*use this string for a default. */
            if (b == "") b = "testing123testing";                                                   /* "    "     "    "  "    "     */
            Console.WriteLine("string A = {0}", a);                                                 /*echo string  A  to screen.     */
            Console.WriteLine("string B = {0}", b);                                                 /*echo string  B  to screen.     */
            Console.WriteLine("LCsubstr = {0}", LCsubstr(a, b));                                    /*tell Longest Common Substring. */
            Console.ReadKey(true);
        }                                                                                           /*stick a fork in it, we're done.*/

        /*─────────────────────────────────LCSUBSTR subroutine─────────────────────────────────*/
        public static string LCsubstr(string x, string y)                                           /*Longest Common Substring.      */
        {
            string output = "";
            int lenx = x.Length;                                                                    /*shortcut for using the X length*/
            for (int j = 0; j < lenx; j++)                                                          /*step through start points in X.*/
            {
                for (int k = lenx - j; k > -1; k--)                                                 /*step through string lengths.   */
                {
                    string common = x.Substring(j, k);                                              /*extract a common substring.    */
                    if (y.IndexOf(common) > -1 && common.Length > output.Length) output = common;   /*longest?*/
                }                                                                                   /*k*/
            }                                                                                       /*j*/
            return output;                                                                          /*$  is "" if no common string.  */
        }
    }
}
