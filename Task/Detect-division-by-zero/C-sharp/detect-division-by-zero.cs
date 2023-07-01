using System;

namespace RosettaCode {
    class Program {
        static void Main(string[] args) {
            int x = 1;
            int y = 0;
            try {
               int z = x / y;
            } catch (DivideByZeroException e) {
                Console.WriteLine(e);
            }

        }
    }
}
