using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KolakoskiSequence {
    class Crutch {
        public readonly int len;
        public int[] s;
        public int i;

        public Crutch(int len) {
            this.len = len;
            s = new int[len];
            i = 0;
        }

        public void Repeat(int count) {
            for (int j = 0; j < count; j++) {
                if (++i == len) return;
                s[i] = s[i - 1];
            }
        }
    }

    static class Extension {
        public static int NextInCycle(this int[] self, int index) {
            return self[index % self.Length];
        }

        public static int[] Kolakoski(this int[] self, int len) {
            Crutch c = new Crutch(len);

            int k = 0;
            while (c.i < len) {
                c.s[c.i] = self.NextInCycle(k);
                if (c.s[k] > 1) {
                    c.Repeat(c.s[k] - 1);
                }
                if (++c.i == len) return c.s;
                k++;
            }
            return c.s;
        }

        public static bool PossibleKolakoski(this int[] self) {
            int[] rle = new int[self.Length];
            int prev = self[0];
            int count = 1;
            int pos = 0;
            for (int i = 1; i < self.Length; i++) {
                if (self[i] == prev) {
                    count++;
                }
                else {
                    rle[pos++] = count;
                    count = 1;
                    prev = self[i];
                }
            }
            // no point adding final 'count' to rle as we're not going to compare it anyway
            for (int i = 0; i < pos; i++) {
                if (rle[i] != self[i]) {
                    return false;
                }
            }
            return true;
        }

        public static string AsString(this int[] self) {
            StringBuilder sb = new StringBuilder("[");
            int count = 0;
            foreach (var item in self) {
                if (count > 0) {
                    sb.Append(", ");
                }
                sb.Append(item);
                count++;
            }
            return sb.Append("]").ToString();
        }
    }

    class Program {
        static void Main(string[] args) {
            int[][] ias = {
                new int[]{1, 2},
                new int[]{2, 1},
                new int[]{1, 3, 1, 2},
                new int[]{1, 3, 2, 1}
            };
            int[] lens = { 20, 20, 30, 30 };

            for (int i = 0; i < ias.Length; i++) {
                int len = lens[i];
                int[] kol = ias[i].Kolakoski(len);

                Console.WriteLine("First {0} members of the sequence by {1}: ", len, ias[i].AsString());
                Console.WriteLine(kol.AsString());
                Console.WriteLine("Possible Kolakoski sequence? {0}", kol.PossibleKolakoski());
                Console.WriteLine();
            }
        }
    }
}
