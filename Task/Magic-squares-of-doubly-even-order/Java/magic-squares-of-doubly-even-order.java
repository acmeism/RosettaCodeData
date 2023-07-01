public class MagicSquareDoublyEven {

    public static void main(String[] args) {
        int n = 8;
        for (int[] row : magicSquareDoublyEven(n)) {
            for (int x : row)
                System.out.printf("%2s ", x);
            System.out.println();
        }
        System.out.printf("\nMagic constant: %d ", (n * n + 1) * n / 2);
    }

    static int[][] magicSquareDoublyEven(final int n) {
        if (n < 4 || n % 4 != 0)
            throw new IllegalArgumentException("base must be a positive "
                    + "multiple of 4");

        // pattern of count-up vs count-down zones
        int bits = 0b1001_0110_0110_1001;
        int size = n * n;
        int mult = n / 4;  // how many multiples of 4

        int[][] result = new int[n][n];

        for (int r = 0, i = 0; r < n; r++) {
            for (int c = 0; c < n; c++, i++) {
                int bitPos = c / mult + (r / mult) * 4;
                result[r][c] = (bits & (1 << bitPos)) != 0 ? i + 1 : size - i;
            }
        }
        return result;
    }
}
