using System;

class Program
{
    static uint MinOf(uint x, uint y)
    {
        return x < y ? x : y;
    }

    static void ThrowDie(uint nSides, uint nDice, uint s, uint[] counts)
    {
        if (nDice == 0)
        {
            counts[s]++;
            return;
        }
        for (uint i = 1; i <= nSides; i++)
        {
            ThrowDie(nSides, nDice - 1, s + i, counts);
        }
    }

    static double BeatingProbability(uint nSides1, uint nDice1, uint nSides2, uint nDice2)
    {
        uint len1 = (nSides1 + 1) * nDice1;
        uint[] c1 = new uint[len1]; // initialized to zero by default
        ThrowDie(nSides1, nDice1, 0, c1);

        uint len2 = (nSides2 + 1) * nDice2;
        uint[] c2 = new uint[len2];
        ThrowDie(nSides2, nDice2, 0, c2);
        double p12 = Math.Pow(nSides1, nDice1) * Math.Pow(nSides2, nDice2);

        double tot = 0.0;
        for (uint i = 0; i < len1; i++)
        {
            for (uint j = 0; j < MinOf(i, len2); j++)
            {
                tot += (double)(c1[i] * c2[j]) / p12;
            }
        }
        return tot;
    }

    static void Main(string[] args)
    {
        Console.WriteLine(BeatingProbability(4, 9, 6, 6));
        Console.WriteLine(BeatingProbability(10, 5, 7, 6));
    }
}
