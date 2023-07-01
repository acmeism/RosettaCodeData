import java.io.*;
import static java.lang.String.format;
import java.util.*;

public class WordSearch {
    static class Grid {
        int numAttempts;
        char[][] cells = new char[nRows][nCols];
        List<String> solutions = new ArrayList<>();
    }

    final static int[][] dirs = {{1, 0}, {0, 1}, {1, 1}, {1, -1}, {-1, 0},
    {0, -1}, {-1, -1}, {-1, 1}};

    final static int nRows = 10;
    final static int nCols = 10;
    final static int gridSize = nRows * nCols;
    final static int minWords = 25;

    final static Random rand = new Random();

    public static void main(String[] args) {
        printResult(createWordSearch(readWords("unixdict.txt")));
    }

    static List<String> readWords(String filename) {
        int maxLen = Math.max(nRows, nCols);

        List<String> words = new ArrayList<>();
        try (Scanner sc = new Scanner(new FileReader(filename))) {
            while (sc.hasNext()) {
                String s = sc.next().trim().toLowerCase();
                if (s.matches("^[a-z]{3," + maxLen + "}$"))
                    words.add(s);
            }
        } catch (FileNotFoundException e) {
            System.out.println(e);
        }
        return words;
    }

    static Grid createWordSearch(List<String> words) {
        Grid grid = null;
        int numAttempts = 0;

        outer:
        while (++numAttempts < 100) {
            Collections.shuffle(words);

            grid = new Grid();
            int messageLen = placeMessage(grid, "Rosetta Code");
            int target = gridSize - messageLen;

            int cellsFilled = 0;
            for (String word : words) {
                cellsFilled += tryPlaceWord(grid, word);
                if (cellsFilled == target) {
                    if (grid.solutions.size() >= minWords) {
                        grid.numAttempts = numAttempts;
                        break outer;
                    } else break; // grid is full but we didn't pack enough words, start over
                }
            }
        }

        return grid;
    }

    static int placeMessage(Grid grid, String msg) {
        msg = msg.toUpperCase().replaceAll("[^A-Z]", "");

        int messageLen = msg.length();
        if (messageLen > 0 && messageLen < gridSize) {
            int gapSize = gridSize / messageLen;

            for (int i = 0; i < messageLen; i++) {
                int pos = i * gapSize + rand.nextInt(gapSize);
                grid.cells[pos / nCols][pos % nCols] = msg.charAt(i);
            }
            return messageLen;
        }
        return 0;
    }

    static int tryPlaceWord(Grid grid, String word) {
        int randDir = rand.nextInt(dirs.length);
        int randPos = rand.nextInt(gridSize);

        for (int dir = 0; dir < dirs.length; dir++) {
            dir = (dir + randDir) % dirs.length;

            for (int pos = 0; pos < gridSize; pos++) {
                pos = (pos + randPos) % gridSize;

                int lettersPlaced = tryLocation(grid, word, dir, pos);
                if (lettersPlaced > 0)
                    return lettersPlaced;
            }
        }
        return 0;
    }

    static int tryLocation(Grid grid, String word, int dir, int pos) {

        int r = pos / nCols;
        int c = pos % nCols;
        int len = word.length();

        //  check bounds
        if ((dirs[dir][0] == 1 && (len + c) > nCols)
                || (dirs[dir][0] == -1 && (len - 1) > c)
                || (dirs[dir][1] == 1 && (len + r) > nRows)
                || (dirs[dir][1] == -1 && (len - 1) > r))
            return 0;

        int rr, cc, i, overlaps = 0;

        // check cells
        for (i = 0, rr = r, cc = c; i < len; i++) {
            if (grid.cells[rr][cc] != 0 && grid.cells[rr][cc] != word.charAt(i))
                return 0;
            cc += dirs[dir][0];
            rr += dirs[dir][1];
        }

        // place
        for (i = 0, rr = r, cc = c; i < len; i++) {
            if (grid.cells[rr][cc] == word.charAt(i))
                overlaps++;
            else
                grid.cells[rr][cc] = word.charAt(i);

            if (i < len - 1) {
                cc += dirs[dir][0];
                rr += dirs[dir][1];
            }
        }

        int lettersPlaced = len - overlaps;
        if (lettersPlaced > 0) {
            grid.solutions.add(format("%-10s (%d,%d)(%d,%d)", word, c, r, cc, rr));
        }

        return lettersPlaced;
    }

    static void printResult(Grid grid) {
        if (grid == null || grid.numAttempts == 0) {
            System.out.println("No grid to display");
            return;
        }
        int size = grid.solutions.size();

        System.out.println("Attempts: " + grid.numAttempts);
        System.out.println("Number of words: " + size);

        System.out.println("\n     0  1  2  3  4  5  6  7  8  9");
        for (int r = 0; r < nRows; r++) {
            System.out.printf("%n%d   ", r);
            for (int c = 0; c < nCols; c++)
                System.out.printf(" %c ", grid.cells[r][c]);
        }

        System.out.println("\n");

        for (int i = 0; i < size - 1; i += 2) {
            System.out.printf("%s   %s%n", grid.solutions.get(i),
                    grid.solutions.get(i + 1));
        }
        if (size % 2 == 1)
            System.out.println(grid.solutions.get(size - 1));
    }
}
