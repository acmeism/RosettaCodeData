using System;
using System.IO;
using System.Numerics;
using System.Threading;
using System.Diagnostics;
using System.Globalization;

namespace Fibonacci {
    class Program
    {
        private static readonly BigInteger[,] F = { { BigInteger.One, BigInteger.One }, { BigInteger.One, BigInteger.Zero } };
        private static NumberFormatInfo nfi  = new NumberFormatInfo { NumberGroupSeparator = "_" };
        private static BigInteger[,] Multiply(in BigInteger[,] A, in BigInteger[,] B)
        {
            if (A.GetLength(1) != B.GetLength(0))
            {
                throw new ArgumentException("Illegal matrix dimensions for multiplication.");
            }
            var C = new BigInteger[A.GetLength(0), B.GetLength(1)];
            for (int i = 0; i < A.GetLength(0); ++i)
            {
                for (int j = 0; j < B.GetLength(1); ++j)
                {
                    for (int k = 0; k < A.GetLength(1); ++k)
                    {
                        C[i, j] +=  A[i, k] * B[k, j];
                    }
                }
            }
            return C;
        }
        private static BigInteger[,] Power(in BigInteger[,] A, ulong n)
        {
            if (A.GetLength(1) != A.GetLength(0))
            {
                throw new ArgumentException("Not a square matrix.");
            }
            var C = new BigInteger[A.GetLength(0), A.GetLength(1)];
            for (int i = 0; i < A.GetLength(0); ++i)
            {
                C[i, i] = BigInteger.One;
            }
            if (0 == n) return C;
            var S = new BigInteger[A.GetLength(0), A.GetLength(1)];
            for (int i = 0; i < A.GetLength(0); ++i)
            {
                for (int j = 0; j < A.GetLength(1); ++j)
                {
                    S[i, j] = A[i, j];
                }
            }
            while (0 < n)
            {
                if (1 == n % 2) C = Multiply(C, S);
                S = Multiply(S,S);
                n /= 2;
            }
            return C;
        }
        public static BigInteger Fib(in ulong n)
        {
            var C = Power(F, n);
            return C[0, 1];
        }
        public static void Task(in ulong p)
        {
            var ans = Fib(p).ToString();
            var sp = p.ToString("N0", nfi);
            if (ans.Length <= 40)
            {
                Console.WriteLine("Fibonacci({0}) = {1}", sp, ans);
            }
            else
            {
                Console.WriteLine("Fibonacci({0}) = {1} ... {2}", sp, ans[0..19], ans[^20..]);
            }
        }
        public static void Main()
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            for (ulong p = 10; p <= 10_000_000; p *= 10) {
                Task(p);
            }
            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;
            string elapsedTime = String.Format("{0:00}:{1:00}:{2:00}.{3:00}",
                ts.Hours, ts.Minutes, ts.Seconds,
                ts.Milliseconds / 10);
            Console.WriteLine("Took " + elapsedTime);
        }
    }
}

