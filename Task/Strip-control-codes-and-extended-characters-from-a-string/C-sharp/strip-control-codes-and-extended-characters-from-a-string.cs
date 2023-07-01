using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RosettaCode
{
    class Program
    {
        static void Main(string[] args)
        {
            string test = "string of ☺☻♥♦⌂, may include control characters and other ilk.♫☼§►↔◄";
            Console.WriteLine("Original: {0}", test);
            Console.WriteLine("Stripped of control codes: {0}", StripControlChars(test));
            Console.WriteLine("Stripped of extended: {0}", StripExtended(test));
        }

        static string StripControlChars(string arg)
        {
            char[] arrForm = arg.ToCharArray();
            StringBuilder buffer = new StringBuilder(arg.Length);//This many chars at most

            foreach(char ch in arrForm)
                if (!Char.IsControl(ch)) buffer.Append(ch);//Only add to buffer if not a control char

            return buffer.ToString();
        }

        static string StripExtended(string arg)
        {
            StringBuilder buffer = new StringBuilder(arg.Length); //Max length
            foreach(char ch in arg)
            {
                UInt16 num = Convert.ToUInt16(ch);//In .NET, chars are UTF-16
                //The basic characters have the same code points as ASCII, and the extended characters are bigger
                if((num >= 32u) && (num <= 126u)) buffer.Append(ch);
            }
            return buffer.ToString();
        }
    }
}
