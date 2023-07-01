using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CastingOutNines {
    public static class Helper {
        public static string AsString<T>(this IEnumerable<T> e) {
            var it = e.GetEnumerator();

            StringBuilder builder = new StringBuilder();
            builder.Append("[");

            if (it.MoveNext()) {
                builder.Append(it.Current);
            }
            while (it.MoveNext()) {
                builder.Append(", ");
                builder.Append(it.Current);
            }

            builder.Append("]");
            return builder.ToString();
        }
    }

    class Program {
        static List<int> CastOut(int @base, int start, int end) {
            int[] ran = Enumerable
                .Range(0, @base - 1)
                .Where(a => a % (@base - 1) == (a * a) % (@base - 1))
                .ToArray();
            int x = start / (@base - 1);

            List<int> result = new List<int>();
            while (true) {
                foreach (int n in ran) {
                    int k = (@base - 1) * x + n;
                    if (k < start) {
                        continue;
                    }
                    if (k > end) {
                        return result;
                    }
                    result.Add(k);
                }
                x++;
            }
        }

        static void Main() {
            Console.WriteLine(CastOut(16, 1, 255).AsString());
            Console.WriteLine(CastOut(10, 1, 99).AsString());
            Console.WriteLine(CastOut(17, 1, 288).AsString());
        }
    }
}
