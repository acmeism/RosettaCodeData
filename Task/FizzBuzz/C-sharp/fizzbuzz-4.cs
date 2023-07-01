using System;
using System.Globalization;
using System.Linq;

namespace FizzBuzz
{
    class Program
    {
        static void Main()
        {
            Enumerable.Range(1, 100)
                .GroupBy(e => e % 15 == 0 ? "FizzBuzz" : e % 5 == 0 ? "Buzz" : e % 3 == 0 ? "Fizz" : string.Empty)
                .SelectMany(item => item.Select(x => new {
                    Value = x,
                    Display = String.IsNullOrEmpty(item.Key) ? x.ToString(CultureInfo.InvariantCulture) : item.Key
                }))
                .OrderBy(x => x.Value)
                .Select(x => x.Display)
                .ToList()
                .ForEach(Console.WriteLine);
        }
    }
}
