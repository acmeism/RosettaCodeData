using System;

class Program {
    static void Main(string[] args) {
        int[,] a = new int[10, 10];
        Random r = new Random();

        for (int i = 0; i < 10; i++) {
            for (int j = 0; j < 10; j++) {
                a[i, j] = r.Next(0, 21) + 1;
            }
        }

        for (int i = 0; i < 10; i++) {
            for (int j = 0; j < 10; j++) {
                Console.Write(" {0}", a[i, j]);
                if (a[i, j] == 20) {
                    goto Done;
                }
            }
            Console.WriteLine();
        }
    Done:
        Console.WriteLine();
    }
}
