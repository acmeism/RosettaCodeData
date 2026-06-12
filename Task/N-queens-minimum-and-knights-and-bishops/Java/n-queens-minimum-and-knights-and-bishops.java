import java.util.Arrays;

public class ChessPieces {
    private static boolean[][] board;
    private static int[][] diag1, diag2;
    private static boolean[] diag1Lookup, diag2Lookup;
    private static int n, minCount;
    private static String layout;

    public static boolean isAttacked(String piece, int row, int col) {
        if (piece.equals("Q")) {
            for (int i = 0; i < n; i++) {
                if (board[i][col] || board[row][i]) {
                    return true;
                }
            }
            if (diag1Lookup[diag1[row][col]] || diag2Lookup[diag2[row][col]]) {
                return true;
            }
        } else if (piece.equals("B")) {
            if (diag1Lookup[diag1[row][col]] || diag2Lookup[diag2[row][col]]) {
                return true;
            }
        } else { // piece == "K"
            if (board[row][col]) {
                return true;
            }
            if (row + 2 < n && col - 1 >= 0 && board[row + 2][col - 1]) {
                return true;
            }
            if (row - 2 >= 0 && col - 1 >= 0 && board[row - 2][col - 1]) {
                return true;
            }
            if (row + 2 < n && col + 1 < n && board[row + 2][col + 1]) {
                return true;
            }
            if (row - 2 >= 0 && col + 1 < n && board[row - 2][col + 1]) {
                return true;
            }
            if (row + 1 < n && col + 2 < n && board[row + 1][col + 2]) {
                return true;
            }
            if (row - 1 >= 0 && col + 2 < n && board[row - 1][col + 2]) {
                return true;
            }
            if (row + 1 < n && col - 2 >= 0 && board[row + 1][col - 2]) {
                return true;
            }
            if (row - 1 >= 0 && col - 2 >= 0 && board[row - 1][col - 2]) {
                return true;
            }
        }
        return false;
    }

    public static int abs(int i) {
        return i < 0 ? -i : i;
    }

    public static boolean attacks(String piece, int row, int col, int trow, int tcol) {
        if (piece.equals("Q")) {
            return row == trow || col == tcol || abs(row - trow) == abs(col - tcol);
        } else if (piece.equals("B")) {
            return abs(row - trow) == abs(col - tcol);
        } else { // piece == "K"
            int rd = abs(trow - row);
            int cd = abs(tcol - col);
            return (rd == 1 && cd == 2) || (rd == 2 && cd == 1);
        }
    }

    public static void storeLayout(String piece) {
        StringBuilder sb = new StringBuilder();
        for (boolean[] row : board) {
            for (boolean cell : row) {
                if (cell) {
                    sb.append(piece).append(" ");
                } else {
                    sb.append(". ");
                }
            }
            sb.append("\n");
        }
        layout = sb.toString();
    }

    public static void placePiece(String piece, int countSoFar, int maxCount) {
        if (countSoFar >= minCount) {
            return;
        }
        boolean allAttacked = true;
        int ti = 0, tj = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (!isAttacked(piece, i, j)) {
                    allAttacked = false;
                    ti = i;
                    tj = j;
                    break;
                }
            }
            if (!allAttacked) {
                break;
            }
        }
        if (allAttacked) {
            minCount = countSoFar;
            storeLayout(piece);
            return;
        }
        if (countSoFar <= maxCount) {
            int si = ti, sj = tj;
            if (piece.equals("K")) {
                si = Math.max(0, si - 2);
                sj = Math.max(0, sj - 2);
            }
            for (int i = si; i < n; i++) {
                for (int j = sj; j < n; j++) {
                    if (!isAttacked(piece, i, j)) {
                        if ((i == ti && j == tj) || attacks(piece, i, j, ti, tj)) {
                            board[i][j] = true;
                            if (!piece.equals("K")) {
                                diag1Lookup[diag1[i][j]] = true;
                                diag2Lookup[diag2[i][j]] = true;
                            }
                            placePiece(piece, countSoFar + 1, maxCount);
                            board[i][j] = false;
                            if (!piece.equals("K")) {
                                diag1Lookup[diag1[i][j]] = false;
                                diag2Lookup[diag2[i][j]] = false;
                            }
                        }
                    }
                }
            }
        }
    }

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        String[] pieces = {"Q", "B", "K"};
        int[] limits = {10, 10, 10};
        String[] names = {"Queens", "Bishops", "Knights"};

        for (int p = 0; p < pieces.length; p++) {
            String piece = pieces[p];
            System.out.println(names[p]);
            System.out.println("=======\n");

            for (n = 1; ; n++) {
                board = new boolean[n][n];
                if (!piece.equals("K")) {
                    diag1 = new int[n][n];
                    diag2 = new int[n][n];
                    for (int i = 0; i < n; i++) {
                        for (int j = 0; j < n; j++) {
                            diag1[i][j] = i + j;
                            diag2[i][j] = i - j + n - 1;
                        }
                    }
                    diag1Lookup = new boolean[2 * n - 1];
                    diag2Lookup = new boolean[2 * n - 1];
                }
                minCount = Integer.MAX_VALUE;
                layout = "";
                for (int maxCount = 1; maxCount <= n * n; maxCount++) {
                    placePiece(piece, 0, maxCount);
                    if (minCount <= n * n) {
                        break;
                    }
                }
                System.out.printf("%2d x %-2d : %d\n", n, n, minCount);
                if (n == limits[p]) {
                    System.out.printf("\n%s on a %d x %d board:\n", names[p], n, n);
                    System.out.println("\n" + layout);
                    break;
                }
            }
        }
        long elapsed = System.currentTimeMillis() - start;
        System.out.printf("Took %d ms\n", elapsed);
    }
}

