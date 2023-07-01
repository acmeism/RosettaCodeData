using System;

namespace CalculateE {
    class Program {
        public const double EPSILON = 1.0e-15;

        static void Main(string[] args) {
            ulong fact = 1;
            double e = 2.0;
            double e0;
            uint n = 2;
            do {
                e0 = e;
                fact *= n++;
                e += 1.0 / fact;
            } while (Math.Abs(e - e0) >= EPSILON);
            Console.WriteLine("e = {0:F15}", e);
        }
    }
}
