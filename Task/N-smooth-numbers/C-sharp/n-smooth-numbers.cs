using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

namespace NSmooth {
    class Program {
        static readonly List<BigInteger> primes = new List<BigInteger>();
        static readonly List<int> smallPrimes = new List<int>();

        static Program() {
            primes.Add(2);
            smallPrimes.Add(2);

            BigInteger i = 3;
            while (i <= 521) {
                if (IsPrime(i)) {
                    primes.Add(i);
                    if (i <= 29) {
                        smallPrimes.Add((int)i);
                    }
                }
                i += 2;
            }
        }

        static bool IsPrime(BigInteger value) {
            if (value < 2) return false;

            if (value % 2 == 0) return value == 2;
            if (value % 3 == 0) return value == 3;

            if (value % 5 == 0) return value == 5;
            if (value % 7 == 0) return value == 7;

            if (value % 11 == 0) return value == 11;
            if (value % 13 == 0) return value == 13;

            if (value % 17 == 0) return value == 17;
            if (value % 19 == 0) return value == 19;

            if (value % 23 == 0) return value == 23;

            BigInteger t = 29;
            while (t * t < value) {
                if (value % t == 0) return false;
                value += 2;

                if (value % t == 0) return false;
                value += 4;
            }

            return true;
        }

        static List<BigInteger> NSmooth(int n, int size) {
            if (n < 2 || n > 521) {
                throw new ArgumentOutOfRangeException("n");
            }
            if (size < 1) {
                throw new ArgumentOutOfRangeException("size");
            }

            BigInteger bn = n;
            bool ok = false;
            foreach (var prime in primes) {
                if (bn == prime) {
                    ok = true;
                    break;
                }
            }
            if (!ok) {
                throw new ArgumentException("must be a prime number", "n");
            }

            BigInteger[] ns = new BigInteger[size];
            ns[0] = 1;
            for (int i = 1; i < size; i++) {
                ns[i] = 0;
            }

            List<BigInteger> next = new List<BigInteger>();
            foreach (var prime in primes) {
                if (prime > bn) {
                    break;
                }
                next.Add(prime);
            }

            int[] indices = new int[next.Count];
            for (int i = 0; i < indices.Length; i++) {
                indices[i] = 0;
            }
            for (int m = 1; m < size; m++) {
                ns[m] = next.Min();
                for (int i = 0; i < indices.Length; i++) {
                    if (ns[m] == next[i]) {
                        indices[i]++;
                        next[i] = primes[i] * ns[indices[i]];
                    }
                }
            }

            return ns.ToList();
        }

        static void Println<T>(IEnumerable<T> nums) {
            Console.Write('[');

            var it = nums.GetEnumerator();
            if (it.MoveNext()) {
                Console.Write(it.Current);
            }
            while (it.MoveNext()) {
                Console.Write(", ");
                Console.Write(it.Current);
            }

            Console.WriteLine(']');
        }

        static void Main() {
            foreach (var i in smallPrimes) {
                Console.WriteLine("The first {0}-smooth numbers are:", i);
                Println(NSmooth(i, 25));
                Console.WriteLine();
            }
            foreach (var i in smallPrimes.Skip(1)) {
                Console.WriteLine("The 3,000 to 3,202 {0}-smooth numbers are:", i);
                Println(NSmooth(i, 3_002).Skip(2_999));
                Console.WriteLine();
            }
            foreach (var i in new int[] { 503, 509, 521 }) {
                Console.WriteLine("The 30,000 to 3,019 {0}-smooth numbers are:", i);
                Println(NSmooth(i, 30_019).Skip(29_999));
                Console.WriteLine();
            }
        }
    }
}
