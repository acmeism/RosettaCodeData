using System;

namespace FeigenbaumConstant {
    class Program {
        static void Main(string[] args) {
            var maxIt = 13;
            var maxItJ = 10;
            var a1 = 1.0;
            var a2 = 0.0;
            var d1 = 3.2;
            Console.WriteLine(" i       d");
            for (int i = 2; i <= maxIt; i++) {
                var a = a1 + (a1 - a2) / d1;
                for (int j = 1; j <= maxItJ; j++) {
                    var x = 0.0;
                    var y = 0.0;
                    for (int k = 1; k <= 1<<i; k++) {
                        y = 1.0 - 2.0 * y * x;
                        x = a - x * x;
                    }
                    a -= x / y;
                }
                var d = (a1 - a2) / (a - a1);
                Console.WriteLine("{0,2:d}    {1:f8}", i, d);
                d1 = d;
                a2 = a1;
                a1 = a;
            }
        }
    }
}
