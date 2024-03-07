using System;

class MagicSquare {
    public static int[,] MagicSquareOdd(int n) {
        if (n < 3 || n % 2 == 0) {
            throw new ArgumentException("Base must be odd and > 2");
        }
        int value = 1;
        int gridSize = n * n;
        int c = n / 2, r = 0;
        int[,] result = new int[n, n];

        while (value <= gridSize) {
            result[r, c] = value;
            int newR = r == 0 ? n - 1 : r - 1;
            int newC = c == n - 1 ? 0 : c + 1;
            if (result[newR, newC] != 0) {
                r++;
            } else {
                r = newR;
                c = newC;
            }
            value++;
        }

        return result;
    }

    public static int[,] MagicSquareSinglyEven(int n) {
        if (n < 6 || (n - 2) % 4 != 0) {
            throw new ArgumentException("Base must be a positive multiple of 4 plus 2");
        }

        int size = n * n;
        int halfN = n / 2;
        int subSquareSize = size / 4;
        int[,] subSquare = MagicSquareOdd(halfN);
        int[] quadrantFactors = new int[] {0, 2, 3, 1};
        int[,] result = new int[n, n];

        for (int r = 0; r < n; r++) {
            for (int c = 0; c < n; c++) {
                int quadrant = (r / halfN) * 2 + (c / halfN);
                result[r, c] = subSquare[r % halfN, c % halfN] + quadrantFactors[quadrant] * subSquareSize;
            }
        }

        int nColsLeft = halfN / 2;
        int nColsRight = nColsLeft - 1;

        for (int r = 0; r < halfN; r++) {
            for (int c = 0; c < n; c++) {
                if (c < nColsLeft || c >= n - nColsRight || (c == nColsLeft && r == nColsLeft)) {
                    if (!(c == 0 && r == nColsLeft)) {
                        int tmp = result[r, c];
                        result[r, c] = result[r + halfN, c];
                        result[r + halfN, c] = tmp;
                    }
                }
            }
        }

        return result;
    }

    static void Main(string[] args) {
        const int n = 6;
        try {
            var msse = MagicSquareSinglyEven(n);
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    Console.Write($"{msse[i, j],2} ");
                }
                Console.WriteLine();
            }
            Console.WriteLine($"\nMagic constant: {(n * n + 1) * n / 2}");
        } catch (Exception ex) {
            Console.WriteLine(ex.Message);
        }
    }
}
