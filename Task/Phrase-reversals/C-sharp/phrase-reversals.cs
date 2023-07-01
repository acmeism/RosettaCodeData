using System;
using System.Linq;
namespace ConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            //Reverse() is an extension method on IEnumerable<char>.
            //The constructor takes a char[], so we have to call ToArray()
            Func<string, string> reverse = s => new string(s.Reverse().ToArray());

            string phrase = "rosetta code phrase reversal";
            //Reverse the string
            Console.WriteLine(reverse(phrase));
            //Reverse each individual word in the string, maintaining original string order.
            Console.WriteLine(string.Join(" ", phrase.Split(' ').Select(word => reverse(word))));
            //Reverse the order of each word of the phrase, maintaining the order of characters in each word.
            Console.WriteLine(string.Join(" ", phrase.Split(' ').Reverse()));
        }
    }
}
