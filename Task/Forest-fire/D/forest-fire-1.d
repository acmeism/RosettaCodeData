import std.stdio, std.random, std.string, std.algorithm;

enum treeProb = 0.55; // Original tree probability.
enum fProb =    0.01; // Auto combustion probability.
enum cProb =    0.01; // Tree creation probability.

enum Cell : char { empty=' ', tree='T', fire='#' }
alias World = Cell[][];

bool hasBurningNeighbours(in World world, in ulong r, in ulong c)
pure nothrow @safe @nogc {
    foreach (immutable rowShift; -1 .. 2)
        foreach (immutable colShift; -1 .. 2)
            if ((r + rowShift) >= 0 && (r + rowShift) < world.length &&
                (c + colShift) >= 0 && (c + colShift) < world[0].length &&
                world[r + rowShift][c + colShift] == Cell.fire)
                return true;
    return false;
}

void nextState(in World world, World nextWorld) /*nothrow*/ @safe /*@nogc*/ {
    foreach (r, row; world)
        foreach (c, elem; row)
            final switch (elem) with (Cell) {
                case empty:
                    nextWorld[r][c]= (uniform01 < cProb) ? tree : empty;
                    break;

                case tree:
                    if (world.hasBurningNeighbours(r, c))
                        nextWorld[r][c] = fire;
                    else
                        nextWorld[r][c] = (uniform01 < fProb) ? fire : tree;
                    break;

                case fire:
                    nextWorld[r][c] = empty;
                    break;
            }
}

void main() @safe {
    auto world = new World(8, 65);
    foreach (row; world)
        foreach (ref el; row)
            el = (uniform01 < treeProb) ? Cell.tree : Cell.empty;
    auto nextWorld = new World(world.length, world[0].length);

    foreach (immutable i; 0 .. 4) {
        nextState(world, nextWorld);
        writefln("%(%(%c%)\n%)\n", nextWorld);
        world.swap(nextWorld);
    }
}
