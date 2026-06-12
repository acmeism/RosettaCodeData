using System;
using System.Collections.Generic;

namespace SnakeAndLadder {
    class Program {
        private static Dictionary<int, int> snl = new Dictionary<int, int>() {
            {4, 14},
            {9, 31},
            {17, 7},
            {20, 38},
            {28, 84},
            {40, 59},
            {51, 67},
            {54, 34},
            {62, 19},
            {63, 81},
            {64, 60},
            {71, 91},
            {87, 24},
            {93, 73},
            {95, 75},
            {99, 78},
        };
        private static Random rand = new Random();
        private const bool sixesThrowAgain = true;

        static int Turn(int player, int square) {
            while (true) {
                int roll = rand.Next(1, 6);
                Console.Write("Player {0}, on square {1}, rolls a {2}", player, square, roll);
                if (square + roll > 100) {
                    Console.WriteLine(" but cannot move.");
                } else {
                    square += roll;
                    Console.WriteLine(" and moves to square {0}", square);
                    if (square == 100) return 100;
                    int next = square;
                    if (snl.ContainsKey(square)) {
                        next = snl[square];
                    }
                    if (square < next) {
                        Console.WriteLine("Yay! Landed on a ladder. Climb up to {0}.", next);
                        if (next == 100) return 100;
                        square = next;
                    } else if (square > next) {
                        Console.WriteLine("Oops! Landed on a snake. Slither down to {0}.", next);
                    }
                }
                if (roll < 6 || !sixesThrowAgain) return square;
                Console.WriteLine("Rolled a 6 so roll again.");
            }
        }

        static void Main(string[] args) {
            // three players atarting on square one
            int[] players = { 1, 1, 1 };
            while (true) {
                for (int i = 0; i < players.Length; i++) {
                    int ns = Turn(i + 1, players[i]);
                    if (ns == 100) {
                        Console.WriteLine("Player {0} wins!", i + 1);
                        return;
                    }
                    players[i] = ns;
                    Console.WriteLine();
                }
            }
        }
    }
}
