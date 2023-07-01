using System;
using System.Collections.Generic;

namespace CUSIP {
    class Program {
        static bool IsCusip(string s) {
            if (s.Length != 9) return false;
            int sum = 0;
            for (int i = 0; i <= 7; i++) {
                char c = s[i];

                int v;
                if (c >= '0' && c <= '9') {
                    v = c - 48;
                }
                else if (c >= 'A' && c <= 'Z') {
                    v = c - 55;  // lower case letters apparently invalid
                }
                else if (c == '*') {
                    v = 36;
                }
                else if (c == '#') {
                    v = 38;
                }
                else {
                    return false;
                }
                if (i % 2 == 1) v *= 2;  // check if odd as using 0-based indexing
                sum += v / 10 + v % 10;
            }
            return s[8] - 48 == (10 - (sum % 10)) % 10;
        }

        static void Main(string[] args) {
            List<string> candidates = new List<string>() {
                "037833100",
                "17275R102",
                "38259P508",
                "594918104",
                "68389X106",
                "68389X105"
            };
            foreach (var candidate in candidates) {
                Console.WriteLine("{0} -> {1}", candidate, IsCusip(candidate) ? "correct" : "incorrect");
            }
        }
    }
}
