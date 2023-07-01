using System;
using System.Collections.Generic;

namespace Morse
{
    class Morse
    {
        static void Main(string[] args)
        {
            string word = "sos";
            Dictionary<string, string> Codes = new Dictionary<string, string>
            {
                {"a", ".-   "}, {"b", "-... "}, {"c", "-.-. "}, {"d", "-..  "},
                {"e", ".    "}, {"f", "..-. "}, {"g", "--.  "}, {"h", ".... "},
                {"i", "..   "}, {"j", ".--- "}, {"k", "-.-  "}, {"l", ".-.. "},
                {"m", "--   "}, {"n", "-.   "}, {"o", "---  "}, {"p", ".--. "},
                {"q", "--.- "}, {"r", ".-.  "}, {"s", "...  "}, {"t", "-    "},
                {"u", "..-  "}, {"v", "...- "}, {"w", ".--  "}, {"x", "-..- "},
                {"y", "-.-- "}, {"z", "--.. "}, {"0", "-----"}, {"1", ".----"},
                {"2", "..---"}, {"3", "...--"}, {"4", "....-"}, {"5", "....."},
                {"6", "-...."}, {"7", "--..."}, {"8", "---.."}, {"9", "----."}
            };

            foreach (char c in word.ToCharArray())
            {
                string rslt = Codes[c.ToString()].Trim();
                foreach (char c2 in rslt.ToCharArray())
                {
                    if (c2 == '.')
                        Console.Beep(1000, 250);
                    else
                        Console.Beep(1000, 750);
                }
                System.Threading.Thread.Sleep(50);
            }
        }
    }
}
