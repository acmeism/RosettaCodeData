using System;

namespace SafeAddition {
    class Program {
        static float NextUp(float d) {
            if (d == 0.0) return float.Epsilon;
            if (float.IsNaN(d) || float.IsNegativeInfinity(d) || float.IsPositiveInfinity(d)) return d;

            byte[] bytes = BitConverter.GetBytes(d);
            int dl = BitConverter.ToInt32(bytes, 0);
            dl++;
            bytes = BitConverter.GetBytes(dl);

            return BitConverter.ToSingle(bytes, 0);
        }

        static float NextDown(float d) {
            if (d == 0.0) return -float.Epsilon;
            if (float.IsNaN(d) || float.IsNegativeInfinity(d) || float.IsPositiveInfinity(d)) return d;

            byte[] bytes = BitConverter.GetBytes(d);
            int dl = BitConverter.ToInt32(bytes, 0);
            dl--;
            bytes = BitConverter.GetBytes(dl);

            return BitConverter.ToSingle(bytes, 0);
        }

        static Tuple<float, float> SafeAdd(float a, float b) {
            return new Tuple<float, float>(NextDown(a + b), NextUp(a + b));
        }

        static void Main(string[] args) {
            float a = 1.20f;
            float b = 0.03f;

            Console.WriteLine("({0} + {1}) is in the range {2}", a, b, SafeAdd(a, b));
        }
    }
}
