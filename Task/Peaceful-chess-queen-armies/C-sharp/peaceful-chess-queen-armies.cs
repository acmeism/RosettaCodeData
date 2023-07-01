using System;
using System.Collections.Generic;

namespace PeacefulChessQueenArmies {
    using Position = Tuple<int, int>;

    enum Piece {
        Empty,
        Black,
        White
    }

    class Program {
        static bool IsAttacking(Position queen, Position pos) {
            return queen.Item1 == pos.Item1
                || queen.Item2 == pos.Item2
                || Math.Abs(queen.Item1 - pos.Item1) == Math.Abs(queen.Item2 - pos.Item2);
        }

        static bool Place(int m, int n, List<Position> pBlackQueens, List<Position> pWhiteQueens) {
            if (m == 0) {
                return true;
            }
            bool placingBlack = true;
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    var pos = new Position(i, j);
                    foreach (var queen in pBlackQueens) {
                        if (queen.Equals(pos) || !placingBlack && IsAttacking(queen, pos)) {
                            goto inner;
                        }
                    }
                    foreach (var queen in pWhiteQueens) {
                        if (queen.Equals(pos) || placingBlack && IsAttacking(queen, pos)) {
                            goto inner;
                        }
                    }
                    if (placingBlack) {
                        pBlackQueens.Add(pos);
                        placingBlack = false;
                    } else {
                        pWhiteQueens.Add(pos);
                        if (Place(m - 1, n, pBlackQueens, pWhiteQueens)) {
                            return true;
                        }
                        pBlackQueens.RemoveAt(pBlackQueens.Count - 1);
                        pWhiteQueens.RemoveAt(pWhiteQueens.Count - 1);
                        placingBlack = true;
                    }
                inner: { }
                }
            }
            if (!placingBlack) {
                pBlackQueens.RemoveAt(pBlackQueens.Count - 1);
            }
            return false;
        }

        static void PrintBoard(int n, List<Position> blackQueens, List<Position> whiteQueens) {
            var board = new Piece[n * n];

            foreach (var queen in blackQueens) {
                board[queen.Item1 * n + queen.Item2] = Piece.Black;
            }
            foreach (var queen in whiteQueens) {
                board[queen.Item1 * n + queen.Item2] = Piece.White;
            }

            for (int i = 0; i < board.Length; i++) {
                if (i != 0 && i % n == 0) {
                    Console.WriteLine();
                }
                switch (board[i]) {
                    case Piece.Black:
                        Console.Write("B ");
                        break;
                    case Piece.White:
                        Console.Write("W ");
                        break;
                    case Piece.Empty:
                        int j = i / n;
                        int k = i - j * n;
                        if (j % 2 == k % 2) {
                            Console.Write("  ");
                        } else {
                            Console.Write("# ");
                        }
                        break;
                }
            }

            Console.WriteLine("\n");
        }

        static void Main() {
            var nms = new int[,] {
                {2, 1}, {3, 1}, {3, 2}, {4, 1}, {4, 2}, {4, 3},
                {5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5},
                {6, 1}, {6, 2}, {6, 3}, {6, 4}, {6, 5}, {6, 6},
                {7, 1}, {7, 2}, {7, 3}, {7, 4}, {7, 5}, {7, 6}, {7, 7},
            };
            for (int i = 0; i < nms.GetLength(0); i++) {
                Console.WriteLine("{0} black and {0} white queens on a {1} x {1} board:", nms[i, 1], nms[i, 0]);
                List<Position> blackQueens = new List<Position>();
                List<Position> whiteQueens = new List<Position>();
                if (Place(nms[i, 1], nms[i, 0], blackQueens, whiteQueens)) {
                    PrintBoard(nms[i, 0], blackQueens, whiteQueens);
                } else {
                    Console.WriteLine("No solution exists.\n");
                }
            }
        }
    }
}
