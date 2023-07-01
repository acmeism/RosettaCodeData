using System;

namespace RosettaCode {

    class PascalsTriangle {

        public static void CreateTriangle(int n) {
            if (n > 0) {
                for (int i = 0; i < n; i++) {
                    int c = 1;
                    Console.Write(" ".PadLeft(2 * (n - 1 - i)));
                    for (int k = 0; k <= i; k++) {
                        Console.Write("{0}", c.ToString().PadLeft(3));
                        c = c * (i - k) / (k + 1);
                    }
                    Console.WriteLine();
                }
            }
        }

        public static void Main() {
            CreateTriangle(8);
        }
    }
}
