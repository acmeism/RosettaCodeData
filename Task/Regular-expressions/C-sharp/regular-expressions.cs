using System;
using System.Text.RegularExpressions;

class Program {
    static void Main(string[] args) {
        string str = "I am a string";

        if (new Regex("string$").IsMatch(str)) {
            Console.WriteLine("Ends with string.");
        }

        str = new Regex(" a ").Replace(str, " another ");
        Console.WriteLine(str);
    }
}
