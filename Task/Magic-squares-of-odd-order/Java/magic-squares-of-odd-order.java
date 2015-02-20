public class MagicSquare {

    public static void main(String[] args) {
        int n = 5;
        for (int[] row : magicSquareOdd(n)) {
            for (int x : row)
                System.out.format("%2s ", x);
            System.out.println();
        }
        System.out.printf("\nMagic constant: %d ", (n * n + 1) * n / 2);
    }

    public static int[][] magicSquareOdd(final int base) {
        if (base % 2 == 0 || base < 3)
            throw new IllegalArgumentException("base must be odd and > 2");

        int[][] grid = new int[base][base];
        int r = 0, number = 0;
        int size = base * base;

        int c = base / 2;
        while (number++ < size) {
            grid[r][c] = number;
            if (r == 0) {
                if (c == base - 1) {
                    r++;
                } else {
                    r = base - 1;
                    c++;
                }
            } else {
                if (c == base - 1) {
                    r--;
                    c = 0;
                } else {
                    if (grid[r - 1][c + 1] == 0) {
                        r--;
                        c++;
                    } else {
                        r++;
                    }
                }
            }
        }
        return grid;
    }
}
