using System;
using System.Linq;
using System.Collections.Generic;

public static class OrderedPartitions
{
    public static void Main() {
        var input = new [] { new[] { 0, 0, 0, 0, 0 }, new[] { 2, 0, 2 }, new[] { 1, 1, 1 } };
        foreach (int[] sizes in input) {
            foreach (var partition in Partitions(sizes)) {
                Console.WriteLine(partition.Select(set => set.Delimit(", ").Encase('{','}')).Delimit(", ").Encase('(', ')'));
            }
            Console.WriteLine();
        }
    }

    static IEnumerable<IEnumerable<int[]>> Partitions(params int[] sizes) {
        var enumerators = new IEnumerator<int[]>[sizes.Length];
        var unused = Enumerable.Range(1, sizes.Sum()).ToSortedSet();
        var arrays = sizes.Select(size => new int[size]).ToArray();

        for (int s = 0; s >= 0; ) {
            if (s == sizes.Length) {
                yield return arrays;
                s--;
            }
            if (enumerators[s] == null) {
                enumerators[s] = Combinations(sizes[s], unused.ToArray()).GetEnumerator();
            } else {
                unused.UnionWith(arrays[s]);
            }
            if (enumerators[s].MoveNext()) {
                enumerators[s].Current.CopyTo(arrays[s], 0);
                unused.ExceptWith(arrays[s]);
                s++;
            } else {
                enumerators[s] = null;
                s--;
            }
        }
    }

    static IEnumerable<T[]> Combinations<T>(int count, params T[] array) {
        T[] result = new T[count];
        foreach (int pattern in BitPatterns(array.Length - count, array.Length)) {
            for (int b = 1 << (array.Length - 1), i = 0, r = 0; b > 0; b >>= 1, i++) {
                if ((pattern & b) == 0) result[r++] = array[i];
            }
            yield return result;
        }
    }

    static IEnumerable<int> BitPatterns(int ones, int length) {
        int initial = (1 << ones) - 1;
        int blockMask = (1 << length) - 1;
        for (int v = initial; v >= initial; ) {
            yield return v;
            if (v == 0) break;

            int w = (v | (v - 1)) + 1;
            w |= (((w & -w) / (v & -v)) >> 1) - 1;
            v = w & blockMask;
        }
    }

    static string Delimit<T>(this IEnumerable<T> source, string separator) => string.Join(separator, source);
    static string Encase(this string s, char start, char end) => start + s + end;
}
