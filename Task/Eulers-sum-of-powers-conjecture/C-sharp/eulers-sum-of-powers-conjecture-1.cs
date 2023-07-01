using System;

namespace EulerSumOfPowers {
    class Program {
        const int MAX_NUMBER = 250;

        static void Main(string[] args) {
            bool found = false;
            long[] fifth = new long[MAX_NUMBER];

            for (int i = 1; i <= MAX_NUMBER; i++) {
                long i2 = i * i;
                fifth[i - 1] = i2 * i2 * i;
            }

            for (int a = 0; a < MAX_NUMBER && !found; a++) {
                for (int b = a; b < MAX_NUMBER && !found; b++) {
                    for (int c = b; c < MAX_NUMBER && !found; c++) {
                        for (int d = c; d < MAX_NUMBER && !found; d++) {
                            long sum = fifth[a] + fifth[b] + fifth[c] + fifth[d];
                            int e = Array.BinarySearch(fifth, sum);
                            found = e >= 0;
                            if (found) {
                                Console.WriteLine("{0}^5 + {1}^5 + {2}^5 + {3}^5 = {4}^5", a + 1, b + 1, c + 1, d + 1, e + 1);
                            }
                        }
                    }
                }
            }
        }
    }
}
