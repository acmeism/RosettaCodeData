import std.random : Random, uniform, randomShuffle;
import std.stdio;

immutable int[][] dirs = [
    [1,  0], [ 0,  1], [ 1, 1],
    [1, -1],           [-1, 0],
    [0, -1], [-1, -1], [-1, 1]
];

enum nRows = 10;
enum nCols = 10;
enum gridSize = nRows * nCols;
enum minWords = 25;

auto rnd = Random();

class Grid {
    int numAttempts;
    char[nRows][nCols] cells;
    string[] solutions;

    this() {
        for(int row=0; row<nRows; ++row) {
            cells[row] = 0;
        }
    }
}

void main() {
    printResult(createWordSearch(readWords("unixdict.txt")));
}

string[] readWords(string filename) {
    import std.algorithm : all, max;
    import std.ascii : isAlpha;
    import std.string : chomp, toLower;

    auto maxlen = max(nRows, nCols);

    string[] words;
    auto source = File(filename);
    foreach(line; source.byLine) {
        chomp(line);
        if (line.length >= 3 && line.length <= maxlen) {
            if (all!isAlpha(line)) {
                words ~= line.toLower.idup;
            }
        }
    }

    return words;
}

Grid createWordSearch(string[] words) {
    Grid grid;
    int numAttempts;

    outer:
    while(++numAttempts < 100) {
        randomShuffle(words);

        grid = new Grid();
        int messageLen = placeMessage(grid, "Rosetta Code");
        int target = gridSize - messageLen;

        int cellsFilled;
        foreach (string word; words) {
            cellsFilled += tryPlaceWord(grid, word);
            if (cellsFilled == target) {
                if (grid.solutions.length >= minWords) {
                    grid.numAttempts = numAttempts;
                    break outer;
                } else break; // grid is full but we didn't pack enough words, start over
            }
        }
    }
    return grid;
}

int placeMessage(Grid grid, string msg) {
    import std.algorithm : filter;
    import std.ascii : isUpper;
    import std.conv : to;
    import std.string : toUpper;

    msg = to!string(msg.toUpper.filter!isUpper);

    if (msg.length > 0 && msg.length < gridSize) {
        int gapSize = gridSize / msg.length;

        for (int i=0; i<msg.length; i++) {
            int pos = i * gapSize + uniform(0, gapSize, rnd);
            grid.cells[pos / nCols][pos % nCols] = msg[i];
        }
        return msg.length;
    }
    return 0;
}

int tryPlaceWord(Grid grid, string word) {
    int randDir = uniform(0, dirs.length, rnd);
    int randPos = uniform(0, gridSize, rnd);

    for (int dir=0; dir<dirs.length; dir++) {
        dir = (dir + randDir) % dirs.length;

        for (int pos=0; pos<gridSize; pos++) {
            pos = (pos + randPos) % gridSize;

            int lettersPlaced = tryLocation(grid, word, dir, pos);
            if (lettersPlaced > 0) {
                return lettersPlaced;
            }
        }
    }
    return 0;
}

int tryLocation(Grid grid, string word, int dir, int pos) {
    import std.format;

    int r = pos / nCols;
    int c = pos % nCols;
    int len = word.length;

    //  check bounds
    if ((dirs[dir][0] == 1 && (len + c) > nCols)
            || (dirs[dir][0] == -1 && (len - 1) > c)
            || (dirs[dir][1] == 1 && (len + r) > nRows)
            || (dirs[dir][1] == -1 && (len - 1) > r)) {
        return 0;
    }

    int i, rr, cc, overlaps = 0;

    // check cells
    for (i=0, rr=r, cc=c; i<len; i++) {
        if (grid.cells[rr][cc] != 0 && grid.cells[rr][cc] != word[i]) {
            return 0;
        }
        cc += dirs[dir][0];
        rr += dirs[dir][1];
    }

    // place
    for (i=0, rr=r, cc=c; i<len; i++) {
        if (grid.cells[rr][cc] == word[i]) {
            overlaps++;
        } else {
            grid.cells[rr][cc] = word[i];
        }

        if (i < len - 1) {
            cc += dirs[dir][0];
            rr += dirs[dir][1];
        }
    }

    int lettersPlaced = len - overlaps;
    if (lettersPlaced > 0) {
        grid.solutions ~= format("%-10s (%d,%d)(%d,%d)", word, c, r, cc, rr);
    }

    return lettersPlaced;
}

void printResult(Grid grid) {
    if (grid is null || grid.numAttempts == 0) {
        writeln("No grid to display");
        return;
    }
    int size = grid.solutions.length;

    writeln("Attempts: ", grid.numAttempts);
    writeln("Number of words: ", size);

    writeln("\n     0  1  2  3  4  5  6  7  8  9");
    for (int r=0; r<nRows; r++) {
        writef("\n%d   ", r);
        for (int c=0; c<nCols; c++) {
            writef(" %c ", grid.cells[r][c]);
        }
    }

    writeln;
    writeln;

    for (int i=0; i<size-1; i+=2) {
        writef("%s   %s\n", grid.solutions[i], grid.solutions[i + 1]);
    }
    if (size % 2 == 1) {
        writeln(grid.solutions[size - 1]);
    }
}
