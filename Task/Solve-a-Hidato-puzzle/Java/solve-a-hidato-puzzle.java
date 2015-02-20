import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Hidato {

    private static int[][] board;
    private static int[] given, start;

    public static void main(String[] args) {
        String[] input = {"_ 33 35 _ _ . . .",
            "_ _ 24 22 _ . . .",
            "_ _ _ 21 _ _ . .",
            "_ 26 _ 13 40 11 . .",
            "27 _ _ _ 9 _ 1 .",
            ". . _ _ 18 _ _ .",
            ". . . . _ 7 _ _",
            ". . . . . . 5 _"};

        setup(input);
        printBoard();
        System.out.println("\nFound:");
        solve(start[0], start[1], 1, 0);
        printBoard();
    }

    private static void setup(String[] input) {
        /* This task is not about input validation, so
           we're going to trust the input to be valid */

        String[][] puzzle = new String[input.length][];
        for (int i = 0; i < input.length; i++)
            puzzle[i] = input[i].split(" ");

        int nCols = puzzle[0].length;
        int nRows = puzzle.length;

        List<Integer> list = new ArrayList<>(nRows * nCols);

        board = new int[nRows + 2][nCols + 2];
        for (int[] row : board)
            for (int c = 0; c < nCols + 2; c++)
                row[c] = -1;

        for (int r = 0; r < nRows; r++) {
            String[] row = puzzle[r];
            for (int c = 0; c < nCols; c++) {
                String cell = row[c];
                switch (cell) {
                    case "_":
                        board[r + 1][c + 1] = 0;
                        break;
                    case ".":
                        break;
                    default:
                        int val = Integer.parseInt(cell);
                        board[r + 1][c + 1] = val;
                        list.add(val);
                        if (val == 1)
                            start = new int[]{r + 1, c + 1};
                }
            }
        }
        Collections.sort(list);
        given = new int[list.size()];
        for (int i = 0; i < given.length; i++)
            given[i] = list.get(i);
    }

    private static boolean solve(int r, int c, int n, int next) {
        if (n > given[given.length - 1])
            return true;

        if (board[r][c] != 0 && board[r][c] != n)
            return false;

        if (board[r][c] == 0 && given[next] == n)
            return false;

        int back = board[r][c];
        if (back == n)
            next++;

        board[r][c] = n;
        for (int i = -1; i < 2; i++)
            for (int j = -1; j < 2; j++)
                if (solve(r + i, c + j, n + 1, next))
                    return true;

        board[r][c] = back;
        return false;
    }

    private static void printBoard() {
        for (int[] row : board) {
            for (int c : row) {
                if (c == -1)
                    System.out.print(" . ");
                else
                    System.out.printf(c > 0 ? "%2d " : "__ ", c);
            }
            System.out.println();
        }
    }
}
