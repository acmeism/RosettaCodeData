using System;

namespace KahanSummation {
    class Program {
        static float KahanSum(params float[] fa) {
            float sum = 0.0f;
            float c = 0.0f;
            foreach (float f in fa) {
                float y = f - c;
                float t = sum + y;
                c = (t - sum) - y;
                sum = t;
            }

            return sum;
        }

        static float Epsilon() {
            float eps = 1.0f;
            while (1.0f + eps != 1.0f) eps /= 2.0f;
            return eps;
        }

        static void Main(string[] args) {
            float a = 1.0f;
            float b = Epsilon();
            float c = -b;
            Console.WriteLine("Epsilon      = {0}", b);
            Console.WriteLine("(a + b) + c  = {0}", (a + b) + c);
            Console.WriteLine("Kahan sum    = {0}", KahanSum(a, b, c));
        }
    }
}
