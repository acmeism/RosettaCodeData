import std.stdio, std.conv, std.ascii, std.array, std.string,
       std.algorithm, std.exception, std.range, std.typetuple;

struct Hidato {
    // alias Cell = RangedValue!(int, -1, int.max);
    alias Cell = int;
    alias Pos = size_t;
    enum : Cell { emptyCell = -1, unknownCell = 0 }

    immutable Cell boardMax;
    immutable size_t nCols, nRows;
    Cell[] board;
    Pos[] known;
    bool[] flood;

    this(in string input) @safe pure
    in {
        assert(!input.strip.empty);
    } out {
        assert(nCols > 0 && nRows > 0);
        immutable size = nCols * nRows;
        assert(board.length == size);
        assert(known.length == size + 1);
        assert(flood.length == size);
        assert(boardMax > 0 && boardMax <= size);
        assert(board.reduce!max == boardMax);
        assert(board.canFind(1) && board.canFind(boardMax));
        assert(flood.all!(f => f == 0));
        assert(known.all!(rc => rc >= 0 && rc < size));

        foreach (immutable i, immutable cell; board) {
            assert(cell == Hidato.emptyCell ||
                   cell == Hidato.unknownCell ||
                   (cell >= 1 && cell <= size));
            if (cell > 0)
                assert(i == known[cast(size_t)cell]);
        }
    } body {
        bool[Cell] pathSeen; // A set.
        /*immutable*/ const lines = input.splitLines;
        this.nRows = lines.length;
        this.nCols = lines[0].split.length;

        immutable size = nCols * nRows;
        this.board = new typeof(this.board[0])[size];
        this.board[] = emptyCell;
        this.known = new typeof(this.known[0])[size + 1];
        this.flood = new typeof(this.flood[0])[size];

        auto boardMaxMutable = Cell.min;
        Pos i = 0;

        foreach (immutable row; lines) {
            assert(row.split.length == nCols,
                   text("Wrong cols n.: ", row.split.length));

            foreach (immutable cell; row.split) {
                switch (cell) {
                    case "_":
                        this.board[i] = Hidato.unknownCell;
                        break;
                    case ".":
                        this.board[i] = Hidato.emptyCell;
                        break;
                    default: // Known.
                        immutable val = cell.to!Cell;
                        enforce(val > 0, "Path numbers must be > 0.");
                        enforce(val !in pathSeen,
                                text("Duplicated path number: ", val));
                        pathSeen[val] = true;
                        this.board[i] = val;
                        this.known[val] = i;
                        boardMaxMutable = max(boardMaxMutable, val);
                }
                i++;
            }
        }

        this.boardMax = boardMaxMutable;
    }


    private Pos idx(in size_t r, in size_t c) const pure nothrow {
        return r * nCols + c;
    }

    private uint nNeighbors(in Pos pos, ref Pos[8] neighbours)
    const pure nothrow {
        immutable r = pos / nCols;
        immutable c = pos % nCols;
        typeof(return) n = 0;

        foreach (immutable sr; TypeTuple!(-1, 0, 1)) {
            immutable size_t i = r + sr; // Can wrap-around.
            if (i >= nRows)
                continue;
            foreach (immutable sc; TypeTuple!(-1, 0, 1)) {
                immutable size_t j = c + sc; // Can wrap-around.
                if ((sc != 0 || sr != 0) && j < nCols) {
                    immutable pos2 = idx(i, j);
                    neighbours[n] = pos2;
                    if (board[pos2] != Hidato.emptyCell)
                        n++;
                }
            }
        }

        return n;
    }

    /// Fill all free cells around 'cell' with true and write
    /// output to variable "flood".
    private void floodFill(in Pos pos) pure nothrow {
        Pos[8] n = void;

        // For all neighbours.
        foreach (immutable i; 0 .. nNeighbors(pos, n)) {
            // If pos is not free, choose another neighbour.
            if (board[n[i]] || flood[n[i]])
                continue;
            flood[n[i]] = true;
            floodFill(n[i]);
        }
    }

    /// Check all empty cells are reachable from higher known cells.
    private bool checkConnectity(in uint lowerBound) pure nothrow {
        flood[] = false;

        foreach (immutable i; lowerBound + 1 .. boardMax + 1)
            if (known[i])
                floodFill(known[i]);

        foreach (immutable i; 0 .. nCols * nRows)
            // If there are free cells which could not be
            // reached from floodFill.
            if (!board[i] && !flood[i])
                return false;
        return true;
    }

    private bool fill(in Pos pos, in uint n) pure nothrow {
        if ((board[pos] && board[pos] != n) ||
            (known[n] && known[n] != pos))
            return false;

        if (n == boardMax)
            return true;

        immutable ko = known[n];
        immutable bo = board[pos];
        board[pos] = n;

        Pos[8] p = void;
        if (checkConnectity(n))
            foreach (immutable i; 0 .. nNeighbors(pos, p))
                if (fill(p[i], n + 1))
                    return true;

        board[pos] = bo;
        known[n] = ko;
        return false;
    }

    void solve() pure nothrow
    in {
        assert(!known.empty);
    } body {
        fill(known[1], 1);
    }

    string toString() const pure {
        immutable d = [Hidato.emptyCell: ".",
                       Hidato.unknownCell: "_"];
        immutable form = "%" ~ text(boardMax.text.length + 1) ~ "s";

        string result;
        foreach (immutable r; 0 .. nRows) {
            foreach (immutable c; 0 .. nCols) {
                immutable cell = board[idx(r, c)];
                result ~= format(form, d.get(cell, cell.text));
            }
            result ~= "\n";
        }
        return result;
    }
}

void solveHidato(in string problem) {
    auto game = problem.Hidato;
    writeln("Problem:\n", game);
    game.solve;
    writeln("Solution:\n", game);
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
