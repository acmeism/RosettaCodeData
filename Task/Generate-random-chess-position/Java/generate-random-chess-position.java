import static java.lang.Math.abs;
import java.util.Random;

public class Fen {
    static Random rand = new Random();

    public static void main(String[] args) {
        System.out.println(createFen());
    }

    static String createFen() {
        char[][] grid = new char[8][8];

        placeKings(grid);
        placePieces(grid, "PPPPPPPP", true);
        placePieces(grid, "pppppppp", true);
        placePieces(grid, "RNBQBNR", false);
        placePieces(grid, "rnbqbnr", false);

        return toFen(grid);
    }

    static void placeKings(char[][] grid) {
        int r1, c1, r2, c2;
        while (true) {
            r1 = rand.nextInt(8);
            c1 = rand.nextInt(8);
            r2 = rand.nextInt(8);
            c2 = rand.nextInt(8);
            if (r1 != r2 && abs(r1 - r2) > 1 && abs(c1 - c2) > 1)
                break;
        }
        grid[r1][c1] = 'K';
        grid[r2][c2] = 'k';
    }

    static void placePieces(char[][] grid, String pieces, boolean isPawn) {
        int numToPlace = rand.nextInt(pieces.length());
        for (int n = 0; n < numToPlace; n++) {
            int r, c;
            do {
                r = rand.nextInt(8);
                c = rand.nextInt(8);

            } while (grid[r][c] != 0 || (isPawn && (r == 7 || r == 0)));

            grid[r][c] = pieces.charAt(n);
        }
    }

    static String toFen(char[][] grid) {
        StringBuilder fen = new StringBuilder();
        int countEmpty = 0;
        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                char ch = grid[r][c];
                System.out.printf("%2c ", ch == 0 ? '.' : ch);
                if (ch == 0) {
                    countEmpty++;
                } else {
                    if (countEmpty > 0) {
                        fen.append(countEmpty);
                        countEmpty = 0;
                    }
                    fen.append(ch);
                }
            }
            if (countEmpty > 0) {
                fen.append(countEmpty);
                countEmpty = 0;
            }
            fen.append("/");
            System.out.println();
        }
        return fen.append(" w - - 0 1").toString();
    }
}
