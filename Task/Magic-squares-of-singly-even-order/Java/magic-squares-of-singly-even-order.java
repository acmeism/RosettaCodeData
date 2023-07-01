public class MagicSquareSinglyEven {

    public static void main(String[] args) {
        int n = 6;
        for (int[] row : magicSquareSinglyEven(n)) {
            for (int x : row)
                System.out.printf("%2s ", x);
            System.out.println();
        }
        System.out.printf("\nMagic constant: %d ", (n * n + 1) * n / 2);
    }

    public static int[][] magicSquareOdd(final int n) {
        if (n < 3 || n % 2 == 0)
            throw new IllegalArgumentException("base must be odd and > 2");

        int value = 0;
        int gridSize = n * n;
        int c = n / 2, r = 0;

        int[][] result = new int[n][n];

        while (++value <= gridSize) {
            result[r][c] = value;
            if (r == 0) {
                if (c == n - 1) {
                    r++;
                } else {
                    r = n - 1;
                    c++;
                }
            } else if (c == n - 1) {
                r--;
                c = 0;
            } else if (result[r - 1][c + 1] == 0) {
                r--;
                c++;
            } else {
                r++;
            }
        }
        return result;
    }

    static int[][] magicSquareSinglyEven(final int n) {
        if (n < 6 || (n - 2) % 4 != 0)
            throw new IllegalArgumentException("base must be a positive "
                    + "multiple of 4 plus 2");

        int size = n * n;
        int halfN = n / 2;
        int subSquareSize = size / 4;

        int[][] subSquare = magicSquareOdd(halfN);
        int[] quadrantFactors = {0, 2, 3, 1};
        int[][] result = new int[n][n];

        for (int r = 0; r < n; r++) {
            for (int c = 0; c < n; c++) {
                int quadrant = (r / halfN) * 2 + (c / halfN);
                result[r][c] = subSquare[r % halfN][c % halfN];
                result[r][c] += quadrantFactors[quadrant] * subSquareSize;
            }
        }

        int nColsLeft = halfN / 2;
        int nColsRight = nColsLeft - 1;

        for (int r = 0; r < halfN; r++)
            for (int c = 0; c < n; c++) {
                if (c < nColsLeft || c >= n - nColsRight
                        || (c == nColsLeft && r == nColsLeft)) {

                    if (c == 0 && r == nColsLeft)
                        continue;

                    int tmp = result[r][c];
                    result[r][c] = result[r + halfN][c];
                    result[r + halfN][c] = tmp;
                }
            }

        return result;
    }
}
