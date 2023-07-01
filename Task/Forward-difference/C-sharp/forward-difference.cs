using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static IEnumerable<int> ForwardDifference(IEnumerable<int> sequence, uint order = 1u)
    {
        switch (order)
        {
            case 0u:
                return sequence;
            case 1u:
                return sequence.Skip(1).Zip(sequence, (next, current) => next - current);
            default:
                return ForwardDifference(ForwardDifference(sequence), order - 1u);
        }
    }

    static void Main()
    {
        IEnumerable<int> sequence = new[] { 90, 47, 58, 29, 22, 32, 55, 5, 55, 73 };
        do
        {
            Console.WriteLine(string.Join(", ", sequence));
        } while ((sequence = ForwardDifference(sequence)).Any());
    }
}
