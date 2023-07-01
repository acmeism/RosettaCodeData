using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace StraddlingCheckerboard
{
    class Program
    {
        public readonly static IReadOnlyDictionary<char, string> val2Key;
        public readonly static IReadOnlyDictionary<string, char> key2Val;

        static Program()
        {
            val2Key = new Dictionary<char, string> {
                {'A',"30"},  {'B',"31"}, {'C',"32"},  {'D',"33"},  {'E',"5"},   {'F',"34"},  {'G',"35"},
                {'H',"0"},   {'I',"36"}, {'J',"37"},  {'K',"38"},  {'L',"2"},   {'M',"4"},   {'.',"78"},
                {'N',"39"},  {'/',"79"}, {'O',"1"},   {'0',"790"}, {'P',"70"},  {'1',"791"}, {'Q',"71"},
                {'2',"792"}, {'R',"8"},  {'3',"793"}, {'S',"6"},   {'4',"794"}, {'T',"9"},   {'5',"795"},
                {'U',"72"},  {'6',"796"},{'V',"73"},  {'7',"797"}, {'W',"74"},  {'8',"798"}, {'X',"75"},
                {'9',"799"}, {'Y',"76"}, {'Z',"77"}};

            key2Val = val2Key.ToDictionary(kv => kv.Value, kv => kv.Key);
        }

        public static string Encode(string s)
        {
            return string.Concat(s.ToUpper().ToCharArray()
                .Where(c => val2Key.ContainsKey(c)).Select(c => val2Key[c]));
        }

        public static string Decode(string s)
        {
            return string.Concat(Regex.Matches(s, "79.|7.|3.|.").Cast<Match>()
                .Where(m => key2Val.ContainsKey(m.Value)).Select(m => key2Val[m.Value]));
        }

        static void Main(string[] args)
        {
            var enc = Encode("One night-it was on the twentieth of March, 1888-I was returning");
            Console.WriteLine(enc);
            Console.WriteLine(Decode(enc));

            Console.ReadLine();
        }
    }
}
