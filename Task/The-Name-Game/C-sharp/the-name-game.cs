using System;
using System.Collections.Generic;
using System.Text;

namespace TheNameGame {
    class Program {
        static void PrintVerse(string name) {
            StringBuilder sb = new StringBuilder(name.ToLower());
            sb[0] = Char.ToUpper(sb[0]);
            string x = sb.ToString();
            string y = "AEIOU".IndexOf(x[0]) > -1 ? x.ToLower() : x.Substring(1);
            string b = "b" + y;
            string f = "f" + y;
            string m = "m" + y;
            switch (x[0]) {
                case 'B':
                    b = y;
                    break;
                case 'F':
                    f = y;
                    break;
                case 'M':
                    m = y;
                    break;
            }
            Console.WriteLine("{0}, {0}, bo-{1}", x, b);
            Console.WriteLine("Banana-fana fo-{0}", f);
            Console.WriteLine("Fee-fi-mo-{0}", m);
            Console.WriteLine("{0}!", x);
            Console.WriteLine();
        }

        static void Main(string[] args) {
            List<string> nameList = new List<string>() { "Gary", "Earl", "Billy", "Felix", "Mary", "Steve" };
            nameList.ForEach(PrintVerse);
        }
    }
}
