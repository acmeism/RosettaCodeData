using System;

namespace EbanNumbers {
    struct Interval {
        public int start, end;
        public bool print;

        public Interval(int start, int end, bool print) {
            this.start = start;
            this.end = end;
            this.print = print;
        }
    }

    class Program {
        static void Main() {
            Interval[] intervals = {
                new Interval(2, 1_000, true),
                new Interval(1_000, 4_000, true),
                new Interval(2, 10_000, false),
                new Interval(2, 100_000, false),
                new Interval(2, 1_000_000, false),
                new Interval(2, 10_000_000, false),
                new Interval(2, 100_000_000, false),
                new Interval(2, 1_000_000_000, false),
            };
            foreach (var intv in intervals) {
                if (intv.start == 2) {
                    Console.WriteLine("eban numbers up to and including {0}:", intv.end);
                } else {
                    Console.WriteLine("eban numbers between {0} and {1} (inclusive):", intv.start, intv.end);
                }

                int count = 0;
                for (int i = intv.start; i <= intv.end; i += 2) {
                    int b = i / 1_000_000_000;
                    int r = i % 1_000_000_000;
                    int m = r / 1_000_000;
                    r = i % 1_000_000;
                    int t = r / 1_000;
                    r %= 1_000;
                    if (m >= 30 && m <= 66) m %= 10;
                    if (t >= 30 && t <= 66) t %= 10;
                    if (r >= 30 && r <= 66) r %= 10;
                    if (b == 0 || b == 2 || b == 4 || b == 6) {
                        if (m == 0 || m == 2 || m == 4 || m == 6) {
                            if (t == 0 || t == 2 || t == 4 || t == 6) {
                                if (r == 0 || r == 2 || r == 4 || r == 6) {
                                    if (intv.print) Console.Write("{0} ", i);
                                    count++;
                                }
                            }
                        }
                    }
                }
                if (intv.print) {
                    Console.WriteLine();
                }
                Console.WriteLine("count = {0}\n", count);
            }
        }
    }
}
