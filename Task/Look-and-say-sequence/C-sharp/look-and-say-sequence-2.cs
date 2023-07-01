using System;
using System.Text.RegularExpressions;

namespace RosettaCode_Cs_LookAndSay
{
    public class Program
    {
        public static int Main(string[] args)
        {
            Array.Resize<string>(ref args, 2);
            string ls = args[0] ?? "1";
            int n;
            if (!int.TryParse(args[1], out n)) n = 10;
            do {
                Console.WriteLine(ls);
                if (--n <= 0) break;
                ls = say(look(ls));
            } while(true);

            return 0;
        }

        public static string[] look(string input)
        {
            int i = -1;
            return Array.FindAll(Regex.Split(input, @"((\d)\2*)"),
                delegate(string p) { ++i; i %= 3; return i == 1; }
            );
        }

        public static string say(string[] groups)
        {
            return string.Concat(
                Array.ConvertAll<string, string>(groups,
                    delegate(string p) { return string.Concat(p.Length, p[0]); }
                )
            );
        }
    }
}
