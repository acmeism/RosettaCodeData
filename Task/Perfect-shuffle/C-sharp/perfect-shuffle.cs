using System;
using System.Collections.Generic;
using System.Linq;

public static class PerfectShuffle
{
    static void Main()
    {
        foreach (int input in new [] {8, 24, 52, 100, 1020, 1024, 10000}) {
            int[] numbers = Enumerable.Range(1, input).ToArray();
            Console.WriteLine($"{input} cards: {ShuffleThrough(numbers).Count()}");
        }

        IEnumerable<T[]> ShuffleThrough<T>(T[] original) {
            T[] copy = (T[])original.Clone();
            do {
                yield return copy = Shuffle(copy);
            } while (!Enumerable.SequenceEqual(original, copy));
        }
    }

    public static T[] Shuffle<T>(T[] array) {
        if (array.Length % 2 != 0) throw new ArgumentException("Length must be even.");
        int half = array.Length / 2;
        T[] result = new T[array.Length];
        for (int t = 0, l = 0, r = half; l < half; t+=2, l++, r++) {
            result[t] = array[l];
            result[t+1] = array[r];
        }
        return result;
    }

}
