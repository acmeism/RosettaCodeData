using System;
namespace SubString
{
    class Program
    {
        static void Main(string[] args)
        {
            string s = "0123456789";
            const int n = 3;
            const int m = 2;
            const char c = '3';
            const string z = "345";

            // A: starting from n characters in and of m length;
            Console.WriteLine(s.Substring(n, m));
            // B: starting from n characters in, up to the end of the string;
            Console.WriteLine(s.Substring(n, s.Length - n));
            // C: whole string minus the last character;
            Console.WriteLine(s.Substring(0, s.Length - 1));
            // D: starting from a known character within the string and of m length;
            Console.WriteLine(s.Substring(s.IndexOf(c), m));
            // E: starting from a known substring within the string and of m length.
            Console.WriteLine(s.Substring(s.IndexOf(z), m));
        }
    }
}
