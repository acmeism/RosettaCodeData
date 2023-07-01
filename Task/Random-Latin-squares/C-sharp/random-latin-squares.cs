using System;
using System.Collections.Generic;

namespace RandomLatinSquares {
    using Matrix = List<List<int>>;

    // Taken from https://stackoverflow.com/a/1262619
    static class Helper {
        private static readonly Random rng = new Random();

        public static void Shuffle<T>(this IList<T> list) {
            int n = list.Count;
            while (n > 1) {
                n--;
                int k = rng.Next(n + 1);
                T value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }
    }

    class Program {
        static void PrintSquare(Matrix latin) {
            foreach (var row in latin) {
                Console.Write('[');

                var it = row.GetEnumerator();
                if (it.MoveNext()) {
                    Console.Write(it.Current);
                }
                while (it.MoveNext()) {
                    Console.Write(", ");
                    Console.Write(it.Current);
                }

                Console.WriteLine(']');
            }
            Console.WriteLine();
        }

        static void LatinSquare(int n) {
            if (n <= 0) {
                Console.WriteLine("[]");
                return;
            }

            var latin = new Matrix();
            for (int i = 0; i < n; i++) {
                List<int> temp = new List<int>();
                for (int j = 0; j < n; j++) {
                    temp.Add(j);
                }
                latin.Add(temp);
            }
            // first row
            latin[0].Shuffle();

            // middle row(s)
            for (int i = 1; i < n - 1; i++) {
                bool shuffled = false;

                while (!shuffled) {
                    latin[i].Shuffle();
                    for (int k = 0; k < i; k++) {
                        for (int j = 0; j < n; j++) {
                            if (latin[k][j] == latin[i][j]) {
                                goto shuffling;
                            }
                        }
                    }
                    shuffled = true;

                shuffling: { }
                }
            }

            // last row
            for (int j = 0; j < n; j++) {
                List<bool> used = new List<bool>();
                for (int i = 0; i < n; i++) {
                    used.Add(false);
                }

                for (int i = 0; i < n-1; i++) {
                    used[latin[i][j]] = true;
                }
                for (int k = 0; k < n; k++) {
                    if (!used[k]) {
                        latin[n - 1][j] = k;
                        break;
                    }
                }
            }

            PrintSquare(latin);
        }

        static void Main() {
            LatinSquare(5);
            LatinSquare(5);
            LatinSquare(10); // for good measure
        }
    }
}
