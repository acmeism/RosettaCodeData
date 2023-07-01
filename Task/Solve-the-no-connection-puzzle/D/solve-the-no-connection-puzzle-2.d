import std.stdio, std.algorithm, std.conv, std.string, std.typecons;

// Holes A=0, B=1, ..., H=7
// With connections:
const board = r"
       A   B
      /|\ /|\
     / | X | \
    /  |/ \|  \
   C - D - E - F
    \  |\ /|  /
     \ | X | /
      \|/ \|/
       G   H";

struct Connection { uint a, b; }

immutable Connection[] connections = [
    {0, 2}, {0, 3}, {0, 4}, // A to C,D,E
    {1, 3}, {1, 4}, {1, 5}, // B to D,E,F
    {6, 2}, {6, 3}, {6, 4}, // G to C,D,E
    {7, 3}, {7, 4}, {7, 5}, // H to D,E,F
    {2, 3}, {3, 4}, {4, 5}, // C-D, D-E, E-F
];

alias Pegs = uint[8];

int absDiff(in uint a, in uint b) pure nothrow @safe @nogc {
    return (a > b) ? (a - b) : (b - a);
}

/** Solution is a simple recursive brute force solver,
it stops at the first found solution.
It returns the solution, the number of positions tested,
and the number of pegs swapped. */
Tuple!(Pegs,"p", uint,"tests", uint,"swaps") solve() pure nothrow @safe @nogc {
    uint tests = 0, swaps = 0;
    Pegs p = [1, 2, 3, 4, 5, 6, 7, 8];

    bool recurse(in uint i) nothrow @safe @nogc {
        if (i >= p.length.signed - 1) {
            tests++;
            return connections.all!(c => absDiff(p[c.a], p[c.b]) > 1);
        }

        // Try each remain peg from.
        foreach (immutable j;  i .. p.length) {
            swaps++;
            swap(p[i], p[j]);
            if (recurse(i + 1))
                return true;
            swap(p[i], p[j]);
        }
        return false;
    }

    recurse(0);
    return typeof(return)(p, tests, swaps);
}

void main() {
    immutable sol = solve();
    board.tr("ABCDEFGH", "%(%d%)".format(sol.p)).writeln;
    writeln("Tested ", sol.tests, " positions and did ", sol.swaps, " swaps.");
}
