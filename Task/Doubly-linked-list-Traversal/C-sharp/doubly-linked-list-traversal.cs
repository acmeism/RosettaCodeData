using System;
using System.Collections.Generic;

namespace RosettaCode.DoublyLinkedList
{
    internal static class Program
    {
        private static void Main()
        {
            var list = new LinkedList<char>("hello");

            var current = list.First;
            do
            {
                Console.WriteLine(current.Value);
            } while ((current = current.Next) != null);

            Console.WriteLine();

            current = list.Last;
            do
            {
                Console.WriteLine(current.Value);
            } while ((current = current.Previous) != null);
        }
    }
}
