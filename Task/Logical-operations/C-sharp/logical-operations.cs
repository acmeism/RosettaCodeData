using System;

namespace LogicalOperations
{
    class Program
    {
        static void Main(string[] args)
        {
            bool a = true, b = false;
            Console.WriteLine("a and b is {0}", a && b);
            Console.WriteLine("a or b is {0}", a || b);
            Console.WriteLine("Not a is {0}", !a);
            Console.WriteLine("a exclusive-or b is {0}", a ^ b);
        }
    }
}
