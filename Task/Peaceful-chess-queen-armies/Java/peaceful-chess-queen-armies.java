import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Peaceful {
    enum Piece {
        Empty,
        Black,
        White,
    }

    public static class Position {
        public int x, y;

        public Position(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object obj) {
            if (obj instanceof Position) {
                Position pos = (Position) obj;
                return pos.x == x && pos.y == y;
            }
            return false;
        }
    }

    private static boolean place(int m, int n, List<Position> pBlackQueens, List<Position> pWhiteQueens) {
        if (m == 0) {
            return true;
        }
        boolean placingBlack = true;
        for (int i = 0; i < n; ++i) {
            inner:
            for (int j = 0; j < n; ++j) {
                Position pos = new Position(i, j);
                for (Position queen : pBlackQueens) {
                    if (pos.equals(queen) || !placingBlack && isAttacking(queen, pos)) {
                        continue inner;
                    }
                }
                for (Position queen : pWhiteQueens) {
                    if (pos.equals(queen) || placingBlack && isAttacking(queen, pos)) {
                        continue inner;
                    }
                }
                if (placingBlack) {
                    pBlackQueens.add(pos);
                    placingBlack = false;
                } else {
                    pWhiteQueens.add(pos);
                    if (place(m - 1, n, pBlackQueens, pWhiteQueens)) {
                        return true;
                    }
                    pBlackQueens.remove(pBlackQueens.size() - 1);
                    pWhiteQueens.remove(pWhiteQueens.size() - 1);
                    placingBlack = true;
                }
            }
        }
        if (!placingBlack) {
            pBlackQueens.remove(pBlackQueens.size() - 1);
        }
        return false;
    }

    private static boolean isAttacking(Position queen, Position pos) {
        return queen.x == pos.x
            || queen.y == pos.y
            || Math.abs(queen.x - pos.x) == Math.abs(queen.y - pos.y);
    }

    private static void printBoard(int n, List<Position> blackQueens, List<Position> whiteQueens) {
        Piece[] board = new Piece[n * n];
        Arrays.fill(board, Piece.Empty);

        for (Position queen : blackQueens) {
            board[queen.x + n * queen.y] = Piece.Black;
        }
        for (Position queen : whiteQueens) {
            board[queen.x + n * queen.y] = Piece.White;
        }
        for (int i = 0; i < board.length; ++i) {
            if ((i != 0) && i % n == 0) {
                System.out.println();
            }

            Piece b = board[i];
            if (b == Piece.Black) {
                System.out.print("B ");
            } else if (b == Piece.White) {
                System.out.print("W ");
            } else {
                int j = i / n;
                int k = i - j * n;
                if (j % 2 == k % 2) {
                    System.out.print("• ");
                } else {
                    System.out.print("◦ ");
                }
            }
        }
        System.out.println('\n');
    }

    public static void main(String[] args) {
        List<Position> nms = List.of(
            new Position(2, 1),
            new Position(3, 1),
            new Position(3, 2),
            new Position(4, 1),
            new Position(4, 2),
            new Position(4, 3),
            new Position(5, 1),
            new Position(5, 2),
            new Position(5, 3),
            new Position(5, 4),
            new Position(5, 5),
            new Position(6, 1),
            new Position(6, 2),
            new Position(6, 3),
            new Position(6, 4),
            new Position(6, 5),
            new Position(6, 6),
            new Position(7, 1),
            new Position(7, 2),
            new Position(7, 3),
            new Position(7, 4),
            new Position(7, 5),
            new Position(7, 6),
            new Position(7, 7)
        );
        for (Position nm : nms) {
            int m = nm.y;
            int n = nm.x;
            System.out.printf("%d black and %d white queens on a %d x %d board:\n", m, m, n, n);
            List<Position> blackQueens = new ArrayList<>();
            List<Position> whiteQueens = new ArrayList<>();
            if (place(m, n, blackQueens, whiteQueens)) {
                printBoard(n, blackQueens, whiteQueens);
            } else {
                System.out.println("No solution exists.\n");
            }
        }
    }
}
