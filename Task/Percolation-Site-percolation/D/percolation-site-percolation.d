import std.stdio, std.random, std.array, std.datetime;

enum size_t nCols = 15,
            nRows = 15,
            nSteps = 11,     // Probability granularity.
            nTries = 20_000; // Simulation tries.

enum Cell : char { empty   = ' ', filled  = '#', visited = '.' }
alias Grid = Cell[nCols][nRows];

void initialize(ref Grid grid, in double probability, ref Xorshift rng) {
    foreach (ref row; grid)
        foreach (ref cell; row)
            cell = (rng.uniform01 < probability) ? Cell.empty : Cell.filled;
}

void show(in ref Grid grid) @safe {
    writefln("%(|%(%c%)|\n%)|", grid);
}

bool percolate(ref Grid grid) pure nothrow @safe @nogc {
    bool walk(in size_t r, in size_t c) nothrow @safe @nogc {
        enum bottom = nRows - 1;
        grid[r][c] = Cell.visited;

        if (r < bottom && grid[r + 1][c] == Cell.empty) { // Down.
            if (walk(r + 1, c))
                return true;
        } else if (r == bottom)
            return true;

        if (c && grid[r][c - 1] == Cell.empty) // Left.
            if (walk(r, c - 1))
                return true;

        if (c < nCols - 1 && grid[r][c + 1] == Cell.empty) // Right.
            if (walk(r, c + 1))
                return true;

        if (r && grid[r - 1][c] == Cell.empty) // Up.
            if (walk(r - 1, c))
                return true;

        return false;
    }

    enum startR = 0;
    foreach (immutable c; 0 .. nCols)
        if (grid[startR][c] == Cell.empty)
            if (walk(startR, c))
                return true;
    return false;
}

void main() {
    static struct Counter {
        double prob;
        size_t count;
    }

    StopWatch sw;
    sw.start;

    enum probabilityStep = 1.0 / (nSteps - 1);
    Counter[nSteps] counters;
    foreach (immutable i, ref co; counters)
        co.prob = i * probabilityStep;

    Grid grid;
    bool sampleShown = false;
    auto rng = Xorshift(unpredictableSeed);

    foreach (ref co; counters) {
        foreach (immutable _; 0 .. nTries) {
            grid.initialize(co.prob, rng);
            if (grid.percolate) {
                co.count++;
                if (!sampleShown) {
                    writefln("Percolating sample (%dx%d, probability =%5.2f):",
                             nCols, nRows, co.prob);
                    grid.show;
                    sampleShown = true;
                }
            }
        }
    }
    sw.stop;

    writefln("\nFraction of %d tries that percolate through:", nTries);
    foreach (const co; counters)
        writefln("%1.3f %1.3f", co.prob, co.count / double(nTries));

    writefln("\nSimulations and grid printing performed" ~
             " in %3.2f seconds.", sw.peek.msecs / 1000.0);
}
