using System;

class Program {
    static void Main(string[] args) {
        for (int i = 1; i <= 10; i++) {
            Console.Write(i);

            if (i % 5 == 0) {
                Console.WriteLine();
                continue;
            }

            Console.Write(", ");
        }
    }
}
