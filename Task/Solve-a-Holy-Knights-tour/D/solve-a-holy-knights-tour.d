import std.stdio, std.conv, std.string, std.range, std.algorithm,
       std.typecons, std.typetuple;


struct HolyKnightPuzzle {
    private alias InputCellBaseType = char;
    private enum InputCell : InputCellBaseType { available = '#', unavailable = '.', start='1' }
    private alias Cell = uint;
    private enum : Cell { unknownCell = 0, unavailableCell = Cell.max, startCell=1 } // Special Cell values.

    // Neighbors, [shift row, shift column].
    static struct P { int x, y; }
    alias shifts = TypeTuple!(P(-2, -1), P(2, -1), P(-2, 1), P(2, 1),
                              P(-1, -2), P(1, -2), P(-1, 2), P(1, 2));

    immutable size_t gridWidth, gridHeight;
    private immutable Cell nAvailableCells;
    private /*immutable*/ const InputCell[] flatPuzzle;
    private Cell[] grid; // Flattened mutable game grid.

    @disable this();


    this(in string[] rawPuzzle) pure @safe
    in {
        assert(!rawPuzzle.empty);
        assert(!rawPuzzle[0].empty);
        assert(rawPuzzle.all!(row => row.length == rawPuzzle[0].length)); // Is rectangular.
        assert(rawPuzzle.join.count(InputCell.start) == 1); // Exactly one start point.
    } body {
        //immutable puzzle = rawPuzzle.to!(InputCell[][]);
        immutable puzzle = rawPuzzle.map!representation.array.to!(InputCell[][]);

        gridWidth = puzzle[0].length;
        gridHeight = puzzle.length;
        flatPuzzle = puzzle.join;

        // This counts the start cell too.
        nAvailableCells = flatPuzzle.representation.count!(ic => ic != InputCell.unavailable);

        grid = flatPuzzle
               .map!(ic => ic.predSwitch(InputCell.available,   unknownCell,
                                         InputCell.unavailable, unavailableCell,
                                         InputCell.start,       startCell))
               .array;
    }


    Nullable!(string[][]) solve(size_t width)() pure /*nothrow*/ @safe
    out(result) {
        if (!result.isNull)
            assert(!grid.canFind(unknownCell));
    } body {
        assert(width == gridWidth);

        // Find start position.
        foreach (immutable r; 0 ..  gridHeight)
            foreach (immutable c; 0 .. width)
                if (grid[r * width + c] == startCell &&
                    search!width(r, c, startCell + 1)) {
                    auto result = zip(flatPuzzle, grid) // Not nothrow.
                                  //.map!({p, c} => ...
                                  .map!(pc => (pc[0] == InputCell.available) ?
                                              pc[1].text :
                                              InputCellBaseType(pc[0]).text)
                                  .array
                                  .chunks(width)
                                  .array;
                    return typeof(return)(result);
                }

        return typeof(return)();
    }


    private bool search(size_t width)(in size_t r, in size_t c, in Cell cell) pure nothrow @safe @nogc {
        if (cell > nAvailableCells)
            return true; // One solution found.

        // This doesn't use the Warnsdorff rule.
        foreach (immutable sh; shifts) {
            immutable r2 = r + sh.x,
                      c2 = c + sh.y,
                      pos = r2 * width + c2;
            // No need to test for >= 0 because uint wraps around.
            if (c2 < width && r2 < gridHeight && grid[pos] == unknownCell) {
                grid[pos] = cell;        // Try.
                if (search!width(r2, c2, cell + 1))
                    return true;
                grid[pos] = unknownCell; // Restore.
            }
        }

        return false;
    }
}


void main() @safe {
    // Enum HolyKnightPuzzle to catch malformed puzzles at compile-time.
    enum puzzle1 = ".###....
                    .#.##...
                    .#######
                    ###..#.#
                    #.#..###
                    1######.
                    ..##.#..
                    ...###..".split.HolyKnightPuzzle;

    enum puzzle2 = ".....1.#.....
                    .....#.#.....
                    ....#####....
                    .....###.....
                    ..#..#.#..#..
                    #####...#####
                    ..##.....##..
                    #####...#####
                    ..#..#.#..#..
                    .....###.....
                    ....#####....
                    .....#.#.....
                    .....#.#.....".split.HolyKnightPuzzle;

    foreach (/*enum*/ puzzle; TypeTuple!(puzzle1, puzzle2)) {
        //immutable solution = puzzle.solve!(puzzle.gridWidth);
        enum width = puzzle.gridWidth;
        immutable solution = puzzle.solve!width; // Solved at run-time.
        if (solution.isNull)
            writeln("No solution found for puzzle.\n");
        else
            writefln("One solution:\n%(%-(%2s %)\n%)\n", solution);
    }
}
