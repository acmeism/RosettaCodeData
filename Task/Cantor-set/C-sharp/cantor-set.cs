using System;

namespace CantorSet {
    class Program {
        const int WIDTH = 81;
        const int HEIGHT = 5;
        private static char[,] lines = new char[HEIGHT, WIDTH];

        static Program() {
            for (int i = 0; i < HEIGHT; i++) {
                for (int j = 0; j < WIDTH; j++) {
                    lines[i, j] = '*';
                }
            }
        }

        private static void Cantor(int start, int len, int index) {
            int seg = len / 3;
            if (seg == 0) return;
            for (int i = index; i < HEIGHT; i++) {
                for (int j = start + seg; j < start + seg * 2; j++) {
                    lines[i, j] = ' ';
                }
            }
            Cantor(start, seg, index + 1);
            Cantor(start + seg * 2, seg, index + 1);
        }

        static void Main(string[] args) {
            Cantor(0, WIDTH, 1);
            for (int i = 0; i < HEIGHT; i++) {
                for (int j = 0; j < WIDTH; j++) {
                    Console.Write(lines[i,j]);
                }
                Console.WriteLine();
            }
        }
    }
}
