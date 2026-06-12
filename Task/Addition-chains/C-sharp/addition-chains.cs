using System;

namespace AdditionChains {
    class Program {
        static int[] Prepend(int n, int[] seq) {
            int[] result = new int[seq.Length + 1];
            Array.Copy(seq, 0, result, 1, seq.Length);
            result[0] = n;
            return result;
        }

        static Tuple<int, int> CheckSeq(int pos, int[] seq, int n, int min_len) {
            if (pos > min_len || seq[0] > n) return new Tuple<int, int>(min_len, 0);
            if (seq[0] == n) return new Tuple<int, int>(pos, 1);
            if (pos < min_len) return TryPerm(0, pos, seq, n, min_len);
            return new Tuple<int, int>(min_len, 0);
        }

        static Tuple<int, int> TryPerm(int i, int pos, int[] seq, int n, int min_len) {
            if (i > pos) return new Tuple<int, int>(min_len, 0);

            Tuple<int, int> res1 = CheckSeq(pos + 1, Prepend(seq[0] + seq[i], seq), n, min_len);
            Tuple<int, int> res2 = TryPerm(i + 1, pos, seq, n, res1.Item1);

            if (res2.Item1 < res1.Item1) return res2;
            if (res2.Item1 == res1.Item1) return new Tuple<int, int>(res2.Item1, res1.Item2 + res2.Item2);

            throw new Exception("TryPerm exception");
        }

        static Tuple<int, int> InitTryPerm(int x) {
            return TryPerm(0, 0, new int[] { 1 }, x, 12);
        }

        static void FindBrauer(int num) {
            Tuple<int, int> res = InitTryPerm(num);
            Console.WriteLine();
            Console.WriteLine("N = {0}", num);
            Console.WriteLine("Minimum length of chains: L(n)= {0}", res.Item1);
            Console.WriteLine("Number of minimum length Brauer chains: {0}", res.Item2);
        }

        static void Main(string[] args) {
            int[] nums = new int[] { 7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379 };
            Array.ForEach(nums, n => FindBrauer(n));
        }
    }
}
