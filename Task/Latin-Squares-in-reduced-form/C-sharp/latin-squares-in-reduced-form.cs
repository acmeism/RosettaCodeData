using System;
using System.Collections.Generic;
using System.Linq;

namespace LatinSquares {
    using matrix = List<List<int>>;

    class Program {
        static void Swap<T>(ref T a, ref T b) {
            var t = a;
            a = b;
            b = t;
        }

        static matrix DList(int n, int start) {
            start--; // use 0 basing
            var a = Enumerable.Range(0, n).ToArray();
            a[start] = a[0];
            a[0] = start;
            Array.Sort(a, 1, a.Length - 1);
            var first = a[1];
            // recursive closure permutes a[1:]
            matrix r = new matrix();
            void recurse(int last) {
                if (last == first) {
                    // bottom of recursion. you get here once for each permutation.
                    // test if permutation is deranged.
                    for (int j = 1; j < a.Length; j++) {
                        var v = a[j];
                        if (j == v) {
                            return; //no, ignore it
                        }
                    }
                    // yes, save a copy with 1 based indexing
                    var b = a.Select(v => v + 1).ToArray();
                    r.Add(b.ToList());
                    return;
                }
                for (int i = last; i >= 1; i--) {
                    Swap(ref a[i], ref a[last]);
                    recurse(last - 1);
                    Swap(ref a[i], ref a[last]);
                }
            }
            recurse(n - 1);
            return r;
        }

        static ulong ReducedLatinSquares(int n, bool echo) {
            if (n <= 0) {
                if (echo) {
                    Console.WriteLine("[]\n");
                }
                return 0;
            } else if (n == 1) {
                if (echo) {
                    Console.WriteLine("[1]\n");
                }
                return 1;
            }

            matrix rlatin = new matrix();
            for (int i = 0; i < n; i++) {
                rlatin.Add(new List<int>());
                for (int j = 0; j < n; j++) {
                    rlatin[i].Add(0);
                }
            }
            // first row
            for (int j = 0; j < n; j++) {
                rlatin[0][j] = j + 1;
            }

            ulong count = 0;
            void recurse(int i) {
                var rows = DList(n, i);

                for (int r = 0; r < rows.Count; r++) {
                    rlatin[i - 1] = rows[r];
                    for (int k = 0; k < i - 1; k++) {
                        for (int j = 1; j < n; j++) {
                            if (rlatin[k][j] == rlatin[i - 1][j]) {
                                if (r < rows.Count - 1) {
                                    goto outer;
                                }
                                if (i > 2) {
                                    return;
                                }
                            }
                        }
                    }
                    if (i < n) {
                        recurse(i + 1);
                    } else {
                        count++;
                        if (echo) {
                            PrintSquare(rlatin, n);
                        }
                    }
                outer: { }
                }
            }

            //remaing rows
            recurse(2);
            return count;
        }

        static void PrintSquare(matrix latin, int n) {
            foreach (var row in latin) {
                var it = row.GetEnumerator();
                Console.Write("[");
                if (it.MoveNext()) {
                    Console.Write(it.Current);
                }
                while (it.MoveNext()) {
                    Console.Write(", {0}", it.Current);
                }
                Console.WriteLine("]");
            }
            Console.WriteLine();
        }

        static ulong Factorial(ulong n) {
            if (n <= 0) {
                return 1;
            }
            ulong prod = 1;
            for (ulong i = 2; i < n + 1; i++) {
                prod *= i;
            }
            return prod;
        }

        static void Main() {
            Console.WriteLine("The four reduced latin squares of order 4 are:\n");
            ReducedLatinSquares(4, true);

            Console.WriteLine("The size of the set of reduced latin squares for the following orders");
            Console.WriteLine("and hence the total number of latin squares of these orders are:\n");
            for (int n = 1; n < 7; n++) {
                ulong nu = (ulong)n;

                var size = ReducedLatinSquares(n, false);
                var f = Factorial(nu - 1);
                f *= f * nu * size;
                Console.WriteLine("Order {0}: Size {1} x {2}! x {3}! => Total {4}", n, size, n, n - 1, f);
            }
        }
    }
}
