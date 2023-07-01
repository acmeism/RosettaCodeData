using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaCode.SymmetricDifference
{
    public static class IEnumerableExtension
    {
        public static IEnumerable<T> SymmetricDifference<T>(this IEnumerable<T> @this, IEnumerable<T> that)
        {
            return @this.Except(that).Concat(that.Except(@this));
        }
    }

    class Program
    {
        static void Main()
        {
            var a = new[] { "John", "Bob", "Mary", "Serena" };
            var b = new[] { "Jim", "Mary", "John", "Bob" };

            foreach (var element in a.SymmetricDifference(b))
            {
                Console.WriteLine(element);
            }
        }
    }
}
