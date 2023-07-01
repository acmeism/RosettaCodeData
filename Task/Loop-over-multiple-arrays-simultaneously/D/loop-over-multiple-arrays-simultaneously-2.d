import std.stdio, std.range;

void main () {
    auto a1 = [1, 2];
    auto a2 = [1, 2, 3];
    alias StoppingPolicy sp;

    // Stops when the shortest range is exhausted
    foreach (p; zip(sp.shortest, a1, a2))
        writeln(p.tupleof);
    writeln();

    // Stops when the longest range is exhausted
    foreach (p; zip(sp.longest, a1, a2))
        writeln(p.tupleof);
    writeln();

    // Requires that all ranges are equal
    foreach (p; zip(sp.requireSameLength, a1, a2))
        writeln(p.tupleof);
}
