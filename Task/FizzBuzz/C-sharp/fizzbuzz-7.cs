using System;
using System.Linq;

namespace FizzBuzz
{
    class Program
    {
        static void Main(string[] args)
        {
            Enumerable.Range(1, 100).ToList().ForEach(i => Console.WriteLine(i % 5 == 0 ? string.Format(i % 3 == 0 ? "Fizz{0}" : "{0}", "Buzz") : string.Format(i%3 == 0 ? "Fizz" : i.ToString())));
        }
    }
}
