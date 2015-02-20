import std.stdio, std.algorithm, std.random, std.math, std.array,
       std.range, std.ascii;

alias Cell = ubyte;
alias Grid = Cell[][];
enum Cell notClustered = 1; // Filled cell, but not in a cluster.

Grid initialize(Grid grid, in double prob, ref Xorshift rng) nothrow {
    foreach (row; grid)
        foreach (ref cell; row)
            cell = Cell(rng.uniform01 < prob);
    return grid;
}

void show(in Grid grid) {
    immutable static cell2char = " #" ~ letters;
    writeln('+', "-".replicate(grid.length), '+');
    foreach (row; grid) {
        write('|');
        row.map!(c => c < cell2char.length ? cell2char[c] : '@').write;
        writeln('|');
    }
    writeln('+', "-".replicate(grid.length), '+');
}

size_t countClusters(bool justCount=false)(Grid grid)
pure nothrow @safe @nogc {
    immutable side = grid.length;
    static if (justCount)
        enum Cell clusterID = 2;
    else
        Cell clusterID = 1;

    void walk(in size_t r, in size_t c) nothrow @safe @nogc {
        grid[r][c] = clusterID; // Fill grid.

        if (r < side - 1 && grid[r + 1][c] == notClustered) // Down.
            walk(r + 1, c);
        if (c < side - 1 && grid[r][c + 1] == notClustered) // Right.
            walk(r, c + 1);
        if (c > 0 && grid[r][c - 1] == notClustered) // Left.
            walk(r, c - 1);
        if (r > 0 && grid[r - 1][c] == notClustered) // Up.
            walk(r - 1, c);
    }

    size_t nClusters = 0;

    foreach (immutable r; 0 .. side)
        foreach (immutable c; 0 .. side)
            if (grid[r][c] == notClustered) {
                static if (!justCount)
                    clusterID++;
                nClusters++;
                walk(r, c);
            }
    return nClusters;
}

double clusterDensity(Grid grid, in double prob, ref Xorshift rng) {
    return grid.initialize(prob, rng).countClusters!true /
           double(grid.length ^^ 2);
}

void showDemo(in size_t side, in double prob, ref Xorshift rng) {
    auto grid = new Grid(side, side);
    grid.initialize(prob, rng);
    writefln("Found %d clusters in this %d by %d grid:\n",
             grid.countClusters, side, side);
    grid.show;
}

void main() {
    immutable prob = 0.5;
    immutable nIters = 5;
    auto rng = Xorshift(unpredictableSeed);

    showDemo(15, prob, rng);
    writeln;
    foreach (immutable i; iota(4, 14, 2)) {
        immutable side = 2 ^^ i;
        auto grid = new Grid(side, side);
        immutable density = nIters
                            .iota
                            .map!(_ => grid.clusterDensity(prob, rng))
                            .sum / nIters;
        writefln("n_iters=%3d, p=%4.2f, n=%5d, sim=%7.8f",
                 nIters, prob, side, density);
    }
}
