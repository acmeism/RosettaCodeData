import std.stdio, std.conv, std.string, std.range, std.array, std.typecons, std.algorithm;

struct  {
    alias BitSet8 = ubyte; // A set of 8 bits.
    alias Cell = uint;
    enum : string { unavailableInCell = "#", availableInCell = "." }
    enum : Cell { unavailableCell = Cell.max, availableCell = 0 }

    this(in string inPuzzle) pure @safe {
        const rawPuzzle = inPuzzle.splitLines.map!(row => row.split).array;
        assert(!rawPuzzle.empty);
        assert(!rawPuzzle[0].empty);
        assert(rawPuzzle.all!(row => row.length == rawPuzzle[0].length)); // Is rectangular.

        gridWidth = rawPuzzle[0].length;
        gridHeight = rawPuzzle.length;
        immutable nMaxCells = gridWidth * gridHeight;
        grid = new Cell[nMaxCells];
        auto knownMutable = new bool[nMaxCells + 1];
        uint nAvailableMutable = nMaxCells;
        bool[Cell] seenCells; // To avoid duplicate input numbers.

        uint i = 0;
        foreach (const piece; rawPuzzle.join) {
            if (piece == unavailableInCell) {
                nAvailableMutable--;
                grid[i++] = unavailableCell;
                continue;
            } else if (piece == availableInCell) {
                grid[i] = availableCell;
            } else {
                immutable cell = piece.to!Cell;
                assert(cell > 0 && cell <= nMaxCells);
                assert(cell !in seenCells);
                seenCells[cell] = true;
                knownMutable[cell] = true;
                grid[i] = cell;
            }

            i++;
        }

        known = knownMutable.idup;
        nAvailable = nAvailableMutable;
    }

    @disable this();


    auto solve() pure nothrow @safe @nogc
    out(result) {
        if (!result.isNull) {
            // Can't verify 'result' here because it's const.
            // assert(!result.get.join.canFind(availableCell.text));

            assert(!grid.canFind(availableCell));
            auto values = grid.filter!(c => c != unavailableCell);
            auto interval = iota(reduce!min(values.front, values.dropOne),
                                 reduce!max(values.front, values.dropOne) + 1);
            assert(values.walkLength == interval.length);
            assert(interval.all!(c => values.count(c) == 1)); // Quadratic.
        }
    } body {
        auto result = grid
                      .map!(c => (c == unavailableCell) ? unavailableInCell : c.text)
                      .chunks(gridWidth);
        alias OutRange = Nullable!(typeof(result));

        const start = findStart;
        if (start.isNull)
            return OutRange();

        search(start.r, start.c, start.cell + 1, 1);
        if (start.cell > 1) {
            immutable direction = -1;
            search(start.r, start.c, start.cell + direction, direction);
        }

        if (grid.any!(c => c == availableCell))
            return OutRange();
        else
            return OutRange(result);
    }

    private:


    bool search(in uint r, in uint c, in Cell cell, in int direction)
    pure nothrow @safe @nogc {
        if ((cell > nAvailable && direction > 0) || (cell == 0 && direction < 0) ||
            (cell == nAvailable && known[cell]))
            return true; // One solution found.

        immutable neighbors = getNeighbors(r, c);

        if (known[cell]) {
            foreach (immutable i, immutable rc; shifts) {
                if (neighbors & (1u << i)) {
                    immutable c2 = c + rc[0],
                              r2 = r + rc[1];
                    if (grid[r2 * gridWidth + c2] == cell)
                        if (search(r2, c2, cell + direction, direction))
                            return true;
                }
            }
            return false;
        }

        foreach (immutable i, immutable rc; shifts) {
            if (neighbors & (1u << i)) {
                immutable c2 = c + rc[0],
                          r2 = r + rc[1],
                          pos = r2 * gridWidth + c2;
                if (grid[pos] == availableCell) {
                    grid[pos] = cell;          // Try.
                    if (search(r2, c2, cell + direction, direction))
                        return true;
                    grid[pos] = availableCell; // Restore.
                }
            }
        }
        return false;
    }


    BitSet8 getNeighbors(in uint r, in uint c) const pure nothrow @safe @nogc {
        typeof(return) usable = 0;

        foreach (immutable i, immutable rc; shifts) {
            immutable c2 = c + rc[0],
                      r2 = r + rc[1];
            if (c2 >= gridWidth || r2 >= gridHeight)
                continue;
            if (grid[r2 * gridWidth + c2] != unavailableCell)
                usable |= (1u << i);
        }

        return usable;
    }


    auto findStart() const pure nothrow @safe @nogc {
        alias Triple = Tuple!(uint,"r", uint,"c", Cell,"cell");
        Nullable!Triple result;

        auto cell = Cell.max;
        foreach (immutable r; 0 .. gridHeight) {
            foreach (immutable c; 0 .. gridWidth) {
                immutable pos = gridWidth * r + c;
                if (grid[pos] != availableCell &&
                    grid[pos] != unavailableCell && grid[pos] < cell) {
                    cell = grid[pos];
                    result = Triple(r, c, cell);
                }
            }
        }

        return result;
    }

    static immutable int[2][4] shifts = [[0, -1], [0, 1], [-1, 0], [1, 0]];
    immutable uint gridWidth, gridHeight;
    immutable int nAvailable;
    immutable bool[] known; // Given known cells of the puzzle.
    Cell[] grid;  // Flattened mutable game grid.
}


void main() {
    // enum NumbrixPuzzle to catch malformed puzzles at compile-time.
    enum puzzle1 = ".  .  .  .  .  .  .  .  .
                    .  . 46 45  . 55 74  .  .
                    . 38  .  . 43  .  . 78  .
                    . 35  .  .  .  .  . 71  .
                    .  . 33  .  .  . 59  .  .
                    . 17  .  .  .  .  . 67  .
                    . 18  .  . 11  .  . 64  .
                    .  . 24 21  .  1  2  .  .
                    .  .  .  .  .  .  .  .  .".NumbrixPuzzle;

    enum puzzle2 = ".  .  .  .  .  .  .  .  .
                    . 11 12 15 18 21 62 61  .
                    .  6  .  .  .  .  . 60  .
                    . 33  .  .  .  .  . 57  .
                    . 32  .  .  .  .  . 56  .
                    . 37  .  1  .  .  . 73  .
                    . 38  .  .  .  .  . 72  .
                    . 43 44 47 48 51 76 77  .
                    .  .  .  .  .  .  .  .  .".NumbrixPuzzle;

    enum puzzle3 = "17  .  .  . 11  .  .  . 59
                     . 15  .  .  6  .  . 61  .
                     .  .  3  .  .  . 63  .  .
                     .  .  .  . 66  .  .  .  .
                    23 24  . 68 67 78  . 54 55
                     .  .  .  . 72  .  .  .  .
                     .  . 35  .  .  . 49  .  .
                     . 29  .  . 40  .  . 47  .
                    31  .  .  . 39  .  .  . 45".NumbrixPuzzle;


    foreach (puzzle; [puzzle1, puzzle2, puzzle3]) {
        auto solution = puzzle.solve; // Solved at run-time.
        if (solution.isNull)
            writeln("No solution found for puzzle.\n");
        else
            writefln("One solution:\n%(%-(%2s %)\n%)\n", solution);
    }
}
