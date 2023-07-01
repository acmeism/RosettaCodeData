import std.stdio, std.random, std.array, std.range, std.algorithm;

struct Grid {
    // Not enforced by runtime and type system:
    // a Cell must contain only the flags bits.
    alias Cell = uint;

    enum : Cell { // Cell states (bit flags).
        empty      = 0,
        filled     = 1,
        rightWall  = 2,
        bottomWall = 4
    }

    const size_t nc, nr;
    Cell[] cells;

    this(in size_t nRows, in size_t nCols) pure nothrow {
        nr = nRows;
        nc = nCols;

        // Allocate two addition rows to avoid checking bounds.
        // Bottom row is also required by drippage.
        cells = new Cell[nc * (nr + 2)];
    }

    void initialize(in double prob, ref Xorshift rng) {
        cells[0 .. nc] = bottomWall | rightWall; // First row.

        uint pos = nc;
        foreach (immutable r; 1 .. nr + 1) {
            foreach (immutable c; 1 .. nc)
                cells[pos++] = (uniform01 < prob ?bottomWall : empty) |
                               (uniform01 < prob ? rightWall : empty);
            cells[pos++] = rightWall |
                           (uniform01 < prob ? bottomWall : empty);
        }

        cells[$ - nc .. $] = empty; // Last row.
    }

    bool percolate() pure nothrow @nogc {
        bool fill(in size_t i) pure nothrow @nogc {
            if (cells[i] & filled)
                return false;

            cells[i] |= filled;

            if (i >= cells.length - nc)
                return true; // Success: reached bottom row.

            return (!(cells[i]      & bottomWall) && fill(i + nc)) ||
                   (!(cells[i]      & rightWall)  && fill(i + 1)) ||
                   (!(cells[i - 1]  & rightWall)  && fill(i - 1)) ||
                   (!(cells[i - nc] & bottomWall) && fill(i - nc));
        }

        return iota(nc, nc + nc).any!fill;
    }

    void show() const {
        writeln("+-".replicate(nc), '+');

        foreach (immutable r; 1 .. nr + 2) {
            write(r == nr + 1 ? ' ' : '|');
            foreach (immutable c; 0 .. nc) {
                immutable cell = cells[r * nc + c];
                write((cell & filled) ? (r <= nr ? '#' : 'X') : ' ');
                write((cell & rightWall) ? '|' : ' ');
            }
            writeln;

            if (r == nr + 1)
                return;

            foreach (immutable c; 0 .. nc)
                write((cells[r * nc + c] & bottomWall) ? "+-" : "+ ");
            '+'.writeln;
        }
    }
}

void main() {
    enum uint nr = 10, nc = 10; // N. rows and columns of the grid.
    enum uint nTries = 10_000;  // N. simulations for each probability.
    enum uint nStepsProb = 10;  // N. steps of probability.

    auto rng = Xorshift(2);
    auto g = Grid(nr, nc);
    g.initialize(0.5, rng);
    g.percolate;
    g.show;

    writefln("\nRunning %dx%d grids %d times for each p:",
             nr, nc, nTries);
    foreach (immutable p; 0 .. nStepsProb) {
        immutable probability = p / double(nStepsProb);
        uint nPercolated = 0;
        foreach (immutable i; 0 .. nTries) {
            g.initialize(probability, rng);
            nPercolated += g.percolate;
        }
        writefln("p = %0.2f: %.4f",
                 probability, nPercolated / double(nTries));
    }
}
