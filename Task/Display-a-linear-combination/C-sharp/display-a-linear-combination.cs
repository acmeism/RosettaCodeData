using System;
using System.Collections.Generic;
using System.Text;

namespace DisplayLinearCombination {
    class Program {
        static string LinearCombo(List<int> c) {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < c.Count; i++) {
                int n = c[i];
                if (n < 0) {
                    if (sb.Length == 0) {
                        sb.Append('-');
                    } else {
                        sb.Append(" - ");
                    }
                } else if (n > 0) {
                    if (sb.Length != 0) {
                        sb.Append(" + ");
                    }
                } else {
                    continue;
                }

                int av = Math.Abs(n);
                if (av != 1) {
                    sb.AppendFormat("{0}*", av);
                }
                sb.AppendFormat("e({0})", i + 1);
            }
            if (sb.Length == 0) {
                sb.Append('0');
            }
            return sb.ToString();
        }

        static void Main(string[] args) {
            List<List<int>> combos = new List<List<int>>{
                new List<int> { 1, 2, 3},
                new List<int> { 0, 1, 2, 3},
                new List<int> { 1, 0, 3, 4},
                new List<int> { 1, 2, 0},
                new List<int> { 0, 0, 0},
                new List<int> { 0},
                new List<int> { 1, 1, 1},
                new List<int> { -1, -1, -1},
                new List<int> { -1, -2, 0, -3},
                new List<int> { -1},
            };

            foreach (List<int> c in combos) {
                var arr = "[" + string.Join(", ", c) + "]";
                Console.WriteLine("{0,15} -> {1}", arr, LinearCombo(c));
            }
        }
    }
}
