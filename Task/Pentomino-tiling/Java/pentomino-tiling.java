package pentominotiling;

import java.util.*;

public class PentominoTiling {

    static final char[] symbols = "FILNPTUVWXYZ-".toCharArray();
    static final Random rand = new Random();

    static final int nRows = 8;
    static final int nCols = 8;
    static final int blank = 12;

    static int[][] grid = new int[nRows][nCols];
    static boolean[] placed = new boolean[symbols.length - 1];

    public static void main(String[] args) {
        shuffleShapes();

        for (int r = 0; r < nRows; r++)
            Arrays.fill(grid[r], -1);

        for (int i = 0; i < 4; i++) {
            int randRow, randCol;
            do {
                randRow = rand.nextInt(nRows);
                randCol = rand.nextInt(nCols);
            } while (grid[randRow][randCol] == blank);
            grid[randRow][randCol] = blank;
        }

        if (solve(0, 0)) {
            printResult();
        } else {
            System.out.println("no solution");
        }
    }

    static void shuffleShapes() {
        int n = shapes.length;
        while (n > 1) {
            int r = rand.nextInt(n--);

            int[][] tmp = shapes[r];
            shapes[r] = shapes[n];
            shapes[n] = tmp;

            char tmpSymbol = symbols[r];
            symbols[r] = symbols[n];
            symbols[n] = tmpSymbol;
        }
    }

    static void printResult() {
        for (int[] r : grid) {
            for (int i : r)
                System.out.printf("%c ", symbols[i]);
            System.out.println();
        }
    }

    static boolean tryPlaceOrientation(int[] o, int r, int c, int shapeIndex) {

        for (int i = 0; i < o.length; i += 2) {
            int x = c + o[i + 1];
            int y = r + o[i];
            if (x < 0 || x >= nCols || y < 0 || y >= nRows || grid[y][x] != -1)
                return false;
        }

        grid[r][c] = shapeIndex;
        for (int i = 0; i < o.length; i += 2)
            grid[r + o[i]][c + o[i + 1]] = shapeIndex;

        return true;
    }

    static void removeOrientation(int[] o, int r, int c) {
        grid[r][c] = -1;
        for (int i = 0; i < o.length; i += 2)
            grid[r + o[i]][c + o[i + 1]] = -1;
    }

    static boolean solve(int pos, int numPlaced) {
        if (numPlaced == shapes.length)
            return true;

        int row = pos / nCols;
        int col = pos % nCols;

        if (grid[row][col] != -1)
            return solve(pos + 1, numPlaced);

        for (int i = 0; i < shapes.length; i++) {
            if (!placed[i]) {
                for (int[] orientation : shapes[i]) {

                    if (!tryPlaceOrientation(orientation, row, col, i))
                        continue;

                    placed[i] = true;

                    if (solve(pos + 1, numPlaced + 1))
                        return true;

                    removeOrientation(orientation, row, col);
                    placed[i] = false;
                }
            }
        }
        return false;
    }

    static final int[][] F = {{1, -1, 1, 0, 1, 1, 2, 1}, {0, 1, 1, -1, 1, 0, 2, 0},
    {1, 0, 1, 1, 1, 2, 2, 1}, {1, 0, 1, 1, 2, -1, 2, 0}, {1, -2, 1, -1, 1, 0, 2, -1},
    {0, 1, 1, 1, 1, 2, 2, 1}, {1, -1, 1, 0, 1, 1, 2, -1}, {1, -1, 1, 0, 2, 0, 2, 1}};

    static final int[][] I = {{0, 1, 0, 2, 0, 3, 0, 4}, {1, 0, 2, 0, 3, 0, 4, 0}};

    static final int[][] L = {{1, 0, 1, 1, 1, 2, 1, 3}, {1, 0, 2, 0, 3, -1, 3, 0},
    {0, 1, 0, 2, 0, 3, 1, 3}, {0, 1, 1, 0, 2, 0, 3, 0}, {0, 1, 1, 1, 2, 1, 3, 1},
    {0, 1, 0, 2, 0, 3, 1, 0}, {1, 0, 2, 0, 3, 0, 3, 1}, {1, -3, 1, -2, 1, -1, 1, 0}};

    static final int[][] N = {{0, 1, 1, -2, 1, -1, 1, 0}, {1, 0, 1, 1, 2, 1, 3, 1},
    {0, 1, 0, 2, 1, -1, 1, 0}, {1, 0, 2, 0, 2, 1, 3, 1}, {0, 1, 1, 1, 1, 2, 1, 3},
    {1, 0, 2, -1, 2, 0, 3, -1}, {0, 1, 0, 2, 1, 2, 1, 3}, {1, -1, 1, 0, 2, -1, 3, -1}};

    static final int[][] P = {{0, 1, 1, 0, 1, 1, 2, 1}, {0, 1, 0, 2, 1, 0, 1, 1},
    {1, 0, 1, 1, 2, 0, 2, 1}, {0, 1, 1, -1, 1, 0, 1, 1}, {0, 1, 1, 0, 1, 1, 1, 2},
    {1, -1, 1, 0, 2, -1, 2, 0}, {0, 1, 0, 2, 1, 1, 1, 2}, {0, 1, 1, 0, 1, 1, 2, 0}};

    static final int[][] T = {{0, 1, 0, 2, 1, 1, 2, 1}, {1, -2, 1, -1, 1, 0, 2, 0},
    {1, 0, 2, -1, 2, 0, 2, 1}, {1, 0, 1, 1, 1, 2, 2, 0}};

    static final int[][] U = {{0, 1, 0, 2, 1, 0, 1, 2}, {0, 1, 1, 1, 2, 0, 2, 1},
    {0, 2, 1, 0, 1, 1, 1, 2}, {0, 1, 1, 0, 2, 0, 2, 1}};

    static final int[][] V = {{1, 0, 2, 0, 2, 1, 2, 2}, {0, 1, 0, 2, 1, 0, 2, 0},
    {1, 0, 2, -2, 2, -1, 2, 0}, {0, 1, 0, 2, 1, 2, 2, 2}};

    static final int[][] W = {{1, 0, 1, 1, 2, 1, 2, 2}, {1, -1, 1, 0, 2, -2, 2, -1},
    {0, 1, 1, 1, 1, 2, 2, 2}, {0, 1, 1, -1, 1, 0, 2, -1}};

    static final int[][] X = {{1, -1, 1, 0, 1, 1, 2, 0}};

    static final int[][] Y = {{1, -2, 1, -1, 1, 0, 1, 1}, {1, -1, 1, 0, 2, 0, 3, 0},
    {0, 1, 0, 2, 0, 3, 1, 1}, {1, 0, 2, 0, 2, 1, 3, 0}, {0, 1, 0, 2, 0, 3, 1, 2},
    {1, 0, 1, 1, 2, 0, 3, 0}, {1, -1, 1, 0, 1, 1, 1, 2}, {1, 0, 2, -1, 2, 0, 3, 0}};

    static final int[][] Z = {{0, 1, 1, 0, 2, -1, 2, 0}, {1, 0, 1, 1, 1, 2, 2, 2},
    {0, 1, 1, 1, 2, 1, 2, 2}, {1, -2, 1, -1, 1, 0, 2, -2}};

    static final int[][][] shapes = {F, I, L, N, P, T, U, V, W, X, Y, Z};
}
