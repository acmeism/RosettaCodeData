import std.stdio, std.conv, std.string, std.range, std.algorithm, std.typecons;


struct HopidoPuzzle {
    private alias InputCellBaseType = char;
    private enum InputCell : InputCellBaseType { available = '#', unavailable = '.' }
    private alias Cell = uint;
    private enum : Cell { unknownCell = 0, unavailableCell = Cell.max } // Special Cell values.

    // Neighbors, [shift row, shift column].
    private static immutable int[2][8] shifts = [[-2, -2], [2, -2], [-2, 2], [2, 2],
                                                 [ 0, -3], [0,  3], [-3, 0], [3, 0]];

    private immutable size_t gridWidth, gridHeight;
    private immutable Cell nAvailableCells;
    private /*immutable*/ const InputCell[] flatPuzzle;
    private Cell[] grid; // Flattened mutable game grid.

    @disable this();


    this(in string[] rawPuzzle) pure @safe
    in {
        assert(!rawPuzzle.empty);
        assert(!rawPuzzle[0].empty);
        assert(rawPuzzle.all!(row => row.length == rawPuzzle[0].length)); // Is rectangular.

        // Has at least one start point.
        assert(rawPuzzle.join.representation.canFind(InputCell.available));
    } body {
        //immutable puzzle = rawPuzzle.to!(InputCell[][]);
        immutable puzzle = rawPuzzle.map!representation.array.to!(InputCell[][]);

        gridWidth = puzzle[0].length;
        gridHeight = puzzle.length;
        flatPuzzle = puzzle.join;
        nAvailableCells = flatPuzzle.representation.count!(ic => ic == InputCell.available);

        grid = flatPuzzle
               .representation
               .map!(ic => ic == InputCell.available ? unknownCell : unavailableCell)
               .array;
    }


    Nullable!(string[][]) solve() pure /*nothrow*/ @safe
    out(result) {
        if (!result.isNull)
            assert(!grid.canFind(unknownCell));
    } body {
        // Try all possible start positions.
        foreach (immutable r; 0 ..  gridHeight) {
            foreach (immutable c; 0 .. gridWidth) {
                immutable pos = r * gridWidth + c;
                if (grid[pos] == unknownCell) {
                    immutable Cell startCell = 1; // To lay the first cell value.
                    grid[pos] = startCell;        // Try.
                    if (search(r, c, startCell + 1)) {
                        auto result = zip(flatPuzzle, grid)
                                      //.map!({p, c} => ...
                                      .map!(pc => (pc[0] == InputCell.available) ?
                                                  pc[1].text :
                                                  InputCellBaseType(pc[0]).text)
                                      .array
                                      .chunks(gridWidth)
                                      .array;
                        return typeof(return)(result);
                    }
                    grid[pos] = unknownCell; // Restore.
                }
            }
        }

        return typeof(return)();
    }


    private bool search(in size_t r, in size_t c, in Cell cell) pure nothrow @safe @nogc {
        if (cell > nAvailableCells)
            return true; // One solution found.

        foreach (immutable sh; shifts) {
            immutable r2 = r + sh[0],
                      c2 = c + sh[1],
                      pos = r2 * gridWidth + c2;
            // No need to test for >= 0 because uint wraps around.
            if (c2 < gridWidth && r2 < gridHeight && grid[pos] == unknownCell) {
                grid[pos] = cell;        // Try.
                if (search(r2, c2, cell + 1))
                    return true;
                grid[pos] = unknownCell; // Restore.
            }
        }

        return false;
    }
}


void main() @safe {
    // enum HopidoPuzzle to catch malformed puzzles at compile-time.
    enum puzzle = ".##.##.
                   #######
                   #######
                   .#####.
                   ..###..
                   ...#...".split.HopidoPuzzle;

    immutable solution = puzzle.solve; // Solved at run-time.
    if (solution.isNull)
        writeln("No solution found.");
    else
        writefln("One solution:\n%(%-(%2s %)\n%)", solution);
}
