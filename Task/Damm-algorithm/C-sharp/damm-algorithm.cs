using System;

namespace DammAlgorithm {
    class Program {
        static int[,] table = {
            {0, 3, 1, 7, 5, 9, 8, 6, 4, 2},
            {7, 0, 9, 2, 1, 5, 4, 8, 6, 3},
            {4, 2, 0, 6, 8, 7, 1, 3, 5, 9},
            {1, 7, 5, 0, 9, 8, 3, 4, 2, 6},
            {6, 1, 2, 3, 0, 4, 5, 9, 7, 8},
            {3, 6, 7, 4, 2, 0, 9, 5, 8, 1},
            {5, 8, 6, 9, 7, 2, 0, 1, 3, 4},
            {8, 9, 4, 5, 3, 6, 2, 0, 1, 7},
            {9, 4, 3, 8, 6, 1, 7, 2, 0, 5},
            {2, 5, 8, 1, 4, 3, 6, 7, 9, 0},
        };

        static bool Damm(string s) {
            int interim = 0;
            foreach (char c in s) {
                interim = table[interim, c - '0'];
            }
            return interim == 0;
        }

        static void Main(string[] args) {
            int[] numbers = { 5724, 5727, 112946, 112949 };
            foreach (int number in numbers) {
                bool isValid = Damm(number.ToString());
                if (isValid) {
                    Console.WriteLine("{0,6} is valid", number);
                }
                else {
                    Console.WriteLine("{0,6} is invalid", number);
                }
            }
        }
    }
}
