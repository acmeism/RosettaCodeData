using System;
using System.Collections.Generic;
using System.Linq;

public class WaveletMatrixDemo
{
    // BitRank is a rank data structure for bit vectors
    private class BitRank
    {
        private long[] block;
        private int[] count;

        // Resize resizes the bit vector to the given length
        public void Resize(int num)
        {
            block = new long[((num + 1) >> 6) + 1];
            count = new int[block.Length];
        }

        // Set sets bit at position i
        public void Set(int i, int val)
        {
            if (val == 1)
            {
                block[i >> 6] |= (1L << (i & 63));
            }
        }

        // Build builds the rank structure
        public void Build()
        {
            for (int i = 1; i < block.Length; i++)
            {
                count[i] = count[i - 1] + PopcountLL(block[i - 1]);
            }
        }

        // PopcountLL counts number of 1's in a 64-bit integer
        private int PopcountLL(long n)
        {
            return BitOperations.PopCount(n);
        }

        // Rank1 counts number of 1's in [0, i)
        public int Rank1(int i)
        {
            return count[i >> 6] + PopcountLL(block[i >> 6] & ((1L << (i & 63)) - 1));
        }

        // Rank1FromTo counts number of 1's in [i, j)
        public int Rank1FromTo(int i, int j)
        {
            return Rank1(j) - Rank1(i);
        }

        // Rank0 counts number of 0's in [0, i)
        public int Rank0(int i)
        {
            return i - Rank1(i);
        }

        // Rank0FromTo counts number of 0's in [i, j)
        public int Rank0FromTo(int i, int j)
        {
            return Rank0(j) - Rank0(i);
        }
    }

    // WaveletMatrix is a wavelet matrix data structure
    private class WaveletMatrix
    {
        private int height;
        private BitRank[] B;
        private int[] pos;

        // Constructor creates a new wavelet matrix
        public WaveletMatrix(int[] vec, params int[] sigma)
        {
            int s = 0;
            if (sigma.Length > 0)
            {
                s = sigma[0];
            }
            else
            {
                // Find the maximum element and use that as sigma
                foreach (int v in vec)
                {
                    if (v > s)
                    {
                        s = v;
                    }
                }
                s++;
            }

            Init(vec, s);
        }

        private void Init(int[] vec, int sigma)
        {
            // Calculate height based on sigma value
            if (sigma == 1)
            {
                height = 1;
            }
            else
            {
                height = 64 - BitOperations.LeadingZeroCount((ulong)(sigma - 1));
            }

            B = new BitRank[height];
            pos = new int[height];

            for (int i = 0; i < height; i++)
            {
                B[i] = new BitRank();
                B[i].Resize(vec.Length);

                for (int j = 0; j < vec.Length; j++)
                {
                    B[i].Set(j, Get(vec[j], height - i - 1));
                }

                B[i].Build();

                // Use a local variable to capture the current i value
                int currentLevel = i;
                pos[i] = StablePartition(vec, c => Get(c, height - currentLevel - 1) == 0);
            }
        }

        // StablePartition is equivalent to C++ stable_partition
        private int StablePartition(int[] arr, Func<int, bool> predicate)
        {
            List<int> result = new List<int>(arr.Length);
            List<int> falseValues = new List<int>(arr.Length);

            foreach (int item in arr)
            {
                if (predicate(item))
                {
                    result.Add(item);
                }
                else
                {
                    falseValues.Add(item);
                }
            }

            int partitionPoint = result.Count;
            result.AddRange(falseValues);

            // Update the original array
            for (int i = 0; i < result.Count; i++)
            {
                arr[i] = result[i];
            }

            return partitionPoint;
        }

        // Get returns bit at position i from val
        private int Get(int val, int i)
        {
            return (val >> i) & 1;
        }

        // Rank counts occurrences of val in range [l, r)
        public int Rank(int val, int l, int r)
        {
            return RankSingle(val, r) - RankSingle(val, l);
        }

        // RankSingle counts occurrences of val in range [0, i)
        public int RankSingle(int val, int i)
        {
            int p = 0;
            for (int j = 0; j < height; j++)
            {
                if (Get(val, height - j - 1) == 1)
                {
                    p = pos[j] + B[j].Rank1(p);
                    i = pos[j] + B[j].Rank1(i);
                }
                else
                {
                    p = B[j].Rank0(p);
                    i = B[j].Rank0(i);
                }
            }
            return i - p;
        }

        // Quantile returns kth smallest element in [l, r)
        public int Quantile(int k, int l, int r)
        {
            int res = 0;
            for (int i = 0; i < height; i++)
            {
                int j = B[i].Rank0FromTo(l, r);
                if (j > k)
                {
                    l = B[i].Rank0(l);
                    r = B[i].Rank0(r);
                }
                else
                {
                    l = pos[i] + B[i].Rank1(l);
                    r = pos[i] + B[i].Rank1(r);
                    k -= j;
                    res |= (1 << (height - i - 1));
                }
            }
            return res;
        }

        // RangeFreq counts elements in [l, r) that are in value range [a, b)
        public int RangeFreq(int l, int r, int a, int b)
        {
            return RangeFreqRecursive(l, r, a, b, 0, 1 << height, 0);
        }

        private int RangeFreqRecursive(int i, int j, int a, int b, int l, int r, int x)
        {
            if (i == j || r <= a || b <= l)
            {
                return 0;
            }

            int mid = (l + r) >> 1;
            if (a <= l && r <= b)
            {
                return j - i;
            }
            else
            {
                int left = RangeFreqRecursive(
                    B[x].Rank0(i),
                    B[x].Rank0(j),
                    a, b, l, mid, x + 1
                );
                int right = RangeFreqRecursive(
                    pos[x] + B[x].Rank1(i),
                    pos[x] + B[x].Rank1(j),
                    a, b, mid, r, x + 1
                );
                return left + right;
            }
        }

        // RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found
        public int RangeMin(int l, int r, int a, int b)
        {
            return RangeMinRecursive(l, r, a, b, 0, 1 << height, 0, 0);
        }

        private int RangeMinRecursive(int i, int j, int a, int b, int l, int r, int x, int val)
        {
            if (i == j || r <= a || b <= l)
            {
                return -1;
            }
            if (r - l == 1)
            {
                return val;
            }

            int mid = (l + r) >> 1;
            int res = RangeMinRecursive(
                B[x].Rank0(i),
                B[x].Rank0(j),
                a, b, l, mid, x + 1, val
            );

            if (res < 0)
            {
                return RangeMinRecursive(
                    pos[x] + B[x].Rank1(i),
                    pos[x] + B[x].Rank1(j),
                    a, b, mid, r, x + 1,
                    val + (1 << (height - x - 1))
                );
            }
            else
            {
                return res;
            }
        }
    }

    // Binary search to find index in sorted array
    private static int Find(int[] arr, int x)
    {
        int left = 0;
        int right = arr.Length;
        while (left < right)
        {
            int mid = (left + right) / 2;
            if (arr[mid] < x)
            {
                left = mid + 1;
            }
            else
            {
                right = mid;
            }
        }
        return left;
    }

    // Custom BitOperations class to replicate Java's bit counting functionality
    private static class BitOperations
    {
        public static int PopCount(long x)
        {
            // Implementation of population count (count of set bits)
            ulong value = (ulong)x;
            int count = 0;
            while (value != 0)
            {
                count += (int)(value & 1);
                value >>= 1;
            }
            return count;
        }

        public static int LeadingZeroCount(ulong x)
        {
            // Count the number of leading zeros in a 64-bit integer
            if (x == 0) return 64;

            int count = 0;
            // Test the highest 32 bits
            if ((x & 0xFFFFFFFF00000000UL) == 0)
            {
                count += 32;
                x <<= 32;
            }
            // Test the highest 16 bits
            if ((x & 0xFFFF000000000000UL) == 0)
            {
                count += 16;
                x <<= 16;
            }
            // Test the highest 8 bits
            if ((x & 0xFF00000000000000UL) == 0)
            {
                count += 8;
                x <<= 8;
            }
            // Test the highest 4 bits
            if ((x & 0xF000000000000000UL) == 0)
            {
                count += 4;
                x <<= 4;
            }
            // Test the highest 2 bits
            if ((x & 0xC000000000000000UL) == 0)
            {
                count += 2;
                x <<= 2;
            }
            // Test the highest bit
            if ((x & 0x8000000000000000UL) == 0)
            {
                count += 1;
            }

            return count;
        }
    }

    public static void Main(string[] args)
    {
        int n = 5;
        int[] a = { 3374, 956, 2114, 3415, 3437 };

        int[] input = new int[n];
        Array.Copy(a, input, n);
        int[] backup = new int[n];
        Array.Copy(a, backup, n);

        // Sort and deduplicate the array
        int[] sortedA = new int[n];
        Array.Copy(a, sortedA, n);
        Array.Sort(sortedA);

        // Deduplicate
        List<int> uniqueAList = new List<int>();
        for (int i = 0; i < sortedA.Length; i++)
        {
            if (i == 0 || sortedA[i] != sortedA[i - 1])
            {
                uniqueAList.Add(sortedA[i]);
            }
        }

        // Convert List to array
        int[] uniqueA = uniqueAList.ToArray();

        // Map original values to their indices in the unique array
        for (int i = 0; i < n; i++)
        {
            input[i] = Find(uniqueA, backup[i]);
        }

        int[][] lrkVector = new int[][]
        {
            new int[] { 2, 2, 1 },
            new int[] { 3, 4, 1 },
            new int[] { 4, 5, 1 },
            new int[] { 1, 2, 2 },
            new int[] { 4, 4, 1 }
        };

        WaveletMatrix wm = new WaveletMatrix(input);

        foreach (int[] lrk in lrkVector)
        {
            int l = lrk[0];
            int r = lrk[1];
            int k = lrk[2];
            l--; // Convert to 0-indexed
            Console.WriteLine(uniqueA[wm.Quantile(k - 1, l, r)]);
        }
    }
}
