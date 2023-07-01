using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NegativeBaseNumbers {
    class Program {
        const string DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

        static string EncodeNegativeBase(long n, int b) {
            if (b < -62 || b > -1) {
                throw new ArgumentOutOfRangeException("b");
            }
            if (n == 0) {
                return "0";
            }
            StringBuilder output = new StringBuilder();
            long nn = n;
            while (nn != 0) {
                int rem = (int)(nn % b);
                nn /= b;
                if (rem < 0) {
                    nn++;
                    rem -= b;
                }
                output.Append(DIGITS[rem]);
            }
            return new string(output.ToString().Reverse().ToArray());
        }

        static long DecodeNegativeBase(string ns, int b) {
            if (b < -62 || b > -1) {
                throw new ArgumentOutOfRangeException("b");
            }
            if (ns == "0") {
                return 0;
            }
            long total = 0;
            long bb = 1;
            for (int i = ns.Length - 1; i >= 0; i--) {
                char c = ns[i];
                total += DIGITS.IndexOf(c) * bb;
                bb *= b;
            }
            return total;
        }

        static void Main(string[] args) {
            List<Tuple<long, int>> nbl = new List<Tuple<long, int>>() {
                new Tuple<long, int>(10,-2),
                new Tuple<long, int>(146,-3),
                new Tuple<long, int>(15,-10),
                new Tuple<long, int>(-34025238427,-62),
            };
            foreach (var p in nbl) {
                string ns = EncodeNegativeBase(p.Item1, p.Item2);
                Console.WriteLine("{0,12} encoded in base {1,-3} = {2}", p.Item1, p.Item2, ns);
                long n = DecodeNegativeBase(ns, p.Item2);
                Console.WriteLine("{0,12} decoded in base {1,-3} = {2}", ns, p.Item2, n);
                Console.WriteLine();
            }
        }
    }
}
