//C# program tests the LCS (Longest Common Substring) subroutine.
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
            Console.WriteLine("LCS = {0}", lcs(a, b));                                              /*tell Longest Common Substring. */
            Console.ReadKey(true);
        }                                                                                           /*stick a fork in it, we're done.*/

        /*─────────────────────────────────LCS subroutine─────────────────────────────────*/
        private static string lcs(string a, string b)
        {
           if(b.Length<a.Length){ string t=a; a=b; b=t; }
           for (int n = a.Length; n > 0; n--)
           {
              for (int m = a.Length-n; m <= a.Length-n; m++)
              {
                  string s=a.Substring(m,n);
                  if(b.Contains(s)) return(s);
              }
           }
           return "";
        }
    }
