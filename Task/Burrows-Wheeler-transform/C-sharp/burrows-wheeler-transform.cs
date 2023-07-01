using System;
using System.Collections.Generic;
using System.Linq;

namespace BurrowsWheeler {
    class Program {
        const char STX = (char)0x02;
        const char ETX = (char)0x03;

        private static void Rotate(ref char[] a) {
            char t = a.Last();
            for (int i = a.Length - 1; i > 0; --i) {
                a[i] = a[i - 1];
            }
            a[0] = t;
        }

        // For some reason, strings do not compare how whould be expected
        private static int Compare(string s1, string s2) {
            for (int i = 0; i < s1.Length && i < s2.Length; ++i) {
                if (s1[i] < s2[i]) {
                    return -1;
                }
                if (s2[i] < s1[i]) {
                    return 1;
                }
            }
            if (s1.Length < s2.Length) {
                return -1;
            }
            if (s2.Length < s1.Length) {
                return 1;
            }
            return 0;
        }

        static string Bwt(string s) {
            if (s.Any(a => a == STX || a == ETX)) {
                throw new ArgumentException("Input can't contain STX or ETX");
            }
            char[] ss = (STX + s + ETX).ToCharArray();
            List<string> table = new List<string>();
            for (int i = 0; i < ss.Length; ++i) {
                table.Add(new string(ss));
                Rotate(ref ss);
            }
            table.Sort(Compare);
            return new string(table.Select(a => a.Last()).ToArray());
        }

        static string Ibwt(string r) {
            int len = r.Length;
            List<string> table = new List<string>(new string[len]);
            for (int i = 0; i < len; ++i) {
                for (int j = 0; j < len; ++j) {
                    table[j] = r[j] + table[j];
                }
                table.Sort(Compare);
            }
            foreach (string row in table) {
                if (row.Last() == ETX) {
                    return row.Substring(1, len - 2);
                }
            }
            return "";
        }

        static string MakePrintable(string s) {
            return s.Replace(STX, '^').Replace(ETX, '|');
        }

        static void Main() {
            string[] tests = new string[] {
                "banana",
                "appellee",
                "dogwood",
                "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
                "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
                "\u0002ABC\u0003"
            };

            foreach (string test in tests) {
                Console.WriteLine(MakePrintable(test));
                Console.Write(" --> ");

                string t = "";
                try {
                    t = Bwt(test);
                    Console.WriteLine(MakePrintable(t));
                } catch (Exception e) {
                    Console.WriteLine("ERROR: {0}", e.Message);
                }

                string r = Ibwt(t);
                Console.WriteLine(" --> {0}", r);
                Console.WriteLine();
            }
        }
    }
}
