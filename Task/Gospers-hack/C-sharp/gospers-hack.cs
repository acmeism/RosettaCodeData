using System;

namespace GospersHack;

internal static class Program
{
    // C# >= 10 - .NET >= 6.0
    private static void Main()
    {
        ulong[] startValues = new[] { 1ul, 3ul, 7ul, 15ul };

        foreach(var start in startValues)
        {
            string[] computedValues = new string[10];
            ulong nextValue = start;

            Console.Write($"{start}: ");
            for (int i = 0; i < 10; i++)
            {
                nextValue = GospersHack.Compute(nextValue);
                computedValues[i] = nextValue.ToString();
            }
            Console.WriteLine(string.Join(", ", computedValues));
        }
    }
}

public static class GospersHack
{
    public static ulong Compute(ulong n)
    {
        ulong c = n & (ulong) -(long)n;
        ulong r = n + c;

        return (((r ^ n) >> 2) / c) | r;
    }
}
