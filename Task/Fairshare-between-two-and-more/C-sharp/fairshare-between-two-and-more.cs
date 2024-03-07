using System;
using System.Collections.Generic;

class FairshareBetweenTwoAndMore
{
    static void Main(string[] args)
    {
        foreach (int baseValue in new List<int> { 2, 3, 5, 11 })
        {
            Console.WriteLine($"Base {baseValue} = {string.Join(", ", ThueMorseSequence(25, baseValue))}");
        }
    }

    private static List<int> ThueMorseSequence(int terms, int baseValue)
    {
        List<int> sequence = new List<int>();
        for (int i = 0; i < terms; i++)
        {
            int sum = 0;
            int n = i;
            while (n > 0)
            {
                // Compute the digit sum
                sum += n % baseValue;
                n /= baseValue;
            }
            // Compute the digit sum modulo baseValue.
            sequence.Add(sum % baseValue);
        }
        return sequence;
    }
}
