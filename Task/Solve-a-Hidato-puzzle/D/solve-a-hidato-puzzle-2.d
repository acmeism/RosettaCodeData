import std.stdio, std.string, std.conv, std.array, std.algorithm,
       std.exception;

struct Hidato {
    // alias Cell = RangedValue!(int, -2, int.max);
    alias Cell = int;
    enum : Cell { emptyCell = -2, unknownCell = -1 }

    alias KnownT = int[2][Cell];
    immutable KnownT known;
    immutable Cell boardMax;
    Cell[][] board;

    this(in string input) pure
    in {
        assert(!input.empty);
    } out {
        immutable nRows = board.length;
        immutable nCols = board[0].length;
        assert(boardMax > 0 && boardMax <= nRows * nCols);
        assert(known.length >= 2 && known.length <= nRows * nCols);
        assert(1 in known && boardMax in known);

        foreach (const row; board)
            foreach (immutable cell; row)
                assert(cell == Hidato.emptyCell ||
                       cell == Hidato.unknownCell ||
                       (cell >= 1 && cell <= nRows * nCols));

        foreach (/*immutable*/ n, immutable rc; known) {
            assert(n > 0 && n <= boardMax);
            assert(rc[0] >= 0 && rc[0] < nRows);
            assert(rc[1] >= 0 && rc[1] < nCols);
        }
    } body {
        bool[Cell] pathSeen; // A set.
        KnownT knownMutable;
        const lines = input.splitLines;
        immutable nCols = lines[0].split.length;
        foreach (immutable int r, immutable row; lines) {
            assert(row.split.length == nCols,
                   text("Wrong cols n.: ", row.split.length));
            auto boardRow = new typeof(board[0])(nCols);
            foreach (immutable int c, immutable cell; row.split) {
                switch (cell) {
                    case ".":
                        boardRow[c] = Hidato.emptyCell;
                        break;
                    case "_":
                        boardRow[c] = Hidato.unknownCell;
                        break;
                    default: // Known.
                        immutable val = cell.to!Cell;
                        enforce(val > 0, "Path numbers must be > 0.");
                        enforce(val !in pathSeen,
                                text("Duplicated path number: ", val));
                        pathSeen[val] = true;
                        boardRow[c] = val;
                        knownMutable[val] = [r, c];
                        boardMax = max(boardMax, val);
                }
            }
            board ~= boardRow;
        }

        known = knownMutable.assumeUnique; // Not verified.
    }

    bool solve() pure nothrow
    in {
        assert(1 in known);
    } body {
        bool fill(in int r, in int c, in Cell n) pure nothrow {
            if (n > boardMax)
                return true;

            if (c < 0 || c >= board[0].length ||
                r < 0 || r >= board.length)
                return false;

            if ((board[r][c] != Hidato.unknownCell &&
                 board[r][c] != n) ||
                (n in known && known[n] != [r, c]))
                return false;

            board[r][c] = n;
            foreach (immutable i; -1 .. 2)
                foreach (immutable j; -1 .. 2)
                    if (fill(r + i, c + j, n + 1))
                        return true;

            board[r][c] = Hidato.unknownCell;
            return false;
        }

        return fill(known[1][0], known[1][1], 1);
    }

    string toString() const pure /*nothrow*/ {
        immutable d = [Hidato.emptyCell: ".",
                       Hidato.unknownCell: "_"];
        immutable form = "%" ~ text(boardMax.text.length + 1) ~ "s";

        string result;
        foreach (const row; board) {
            foreach (immutable c; row)
                result ~= format(form, d.get(c, c.text));
            result ~= "\n";
        }
        return result;
    }
}

void solveHidato(in string problem) {
    auto hi = problem.Hidato;
    writeln("Problem:\n", hi);
    hi.solve;
    writeln("Solution:\n", hi);
    writeln;
}

void main() {
    solveHidato(" _ 33 35  _  _  .  .  .
                  _  _ 24 22  _  .  .  .
                  _  _  _ 21  _  _  .  .
                  _ 26  _ 13 40 11  .  .
                 27  _  _  _  9  _  1  .
                  .  .  _  _ 18  _  _  .
                  .  .  .  .  _  7  _  _
                  .  .  .  .  .  .  5  _");

    solveHidato(". 4 .
                 _ 7 _
                 1 _ _");

    solveHidato(
"1 _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . 74
 . . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ . _ .
 . . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ . . _ _ ."
);
}
