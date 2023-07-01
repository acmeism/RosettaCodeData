using System;

namespace PythagoreanQuadruples {
    class Program {
        const int MAX = 2200;
        const int MAX2 = MAX * MAX * 2;

        static void Main(string[] args) {
            bool[] found = new bool[MAX + 1]; // all false by default
            bool[] a2b2 = new bool[MAX2 + 1]; // ditto
            int s = 3;

            for(int a = 1; a <= MAX; a++) {
                int a2 = a * a;
                for (int b=a; b<=MAX; b++) {
                    a2b2[a2 + b * b] = true;
                }
            }

            for (int c = 1; c <= MAX; c++) {
                int s1 = s;
                s += 2;
                int s2 = s;
                for (int d = c + 1; d <= MAX; d++) {
                    if (a2b2[s1]) found[d] = true;
                    s1 += s2;
                    s2 += 2;
                }
            }

            Console.WriteLine("The values of d <= {0} which can't be represented:", MAX);
            for (int d = 1; d < MAX; d++) {
                if (!found[d]) Console.Write("{0}  ", d);
            }
            Console.WriteLine();
        }
    }
}
