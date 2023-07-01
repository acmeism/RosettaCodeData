using System;
using System.Linq;

namespace Four_Squares_Puzzle {
    class Program {
        static void Main(string[] args) {
            fourSquare(1, 7, true, true);
            fourSquare(3, 9, true, true);
            fourSquare(0, 9, false, false);
        }

        private static void fourSquare(int low, int high, bool unique, bool print) {
            int count = 0;

            if (print) {
                Console.WriteLine("a b c d e f g");
            }
            for (int a = low; a <= high; ++a) {
                for (int b = low; b <= high; ++b) {
                    if (notValid(unique, b, a)) continue;

                    int fp = a + b;
                    for (int c = low; c <= high; ++c) {
                        if (notValid(unique, c, b, a)) continue;
                        for (int d = low; d <= high; ++d) {
                            if (notValid(unique, d, c, b, a)) continue;
                            if (fp != b + c + d) continue;

                            for (int e = low; e <= high; ++e) {
                                if (notValid(unique, e, d, c, b, a)) continue;
                                for (int f = low; f <= high; ++f) {
                                    if (notValid(unique, f, e, d, c, b, a)) continue;
                                    if (fp != d + e + f) continue;

                                    for (int g = low; g <= high; ++g) {
                                        if (notValid(unique, g, f, e, d, c, b, a)) continue;
                                        if (fp != f + g) continue;

                                        ++count;
                                        if (print) {
                                            Console.WriteLine("{0} {1} {2} {3} {4} {5} {6}", a, b, c, d, e, f, g);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (unique) {
                Console.WriteLine("There are {0} unique solutions in [{1}, {2}]", count, low, high);
            }
            else {
                Console.WriteLine("There are {0} non-unique solutions in [{1}, {2}]", count, low, high);
            }
        }

        private static bool notValid(bool unique, int needle, params int[] haystack) {
            return unique && haystack.Any(p => p == needle);
        }
    }
}
