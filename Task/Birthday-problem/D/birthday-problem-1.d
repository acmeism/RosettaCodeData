import std.stdio, std.random, std.algorithm, std.conv;

/// For sharing common birthday must all share same common day.
double equalBirthdays(in uint nSharers, in uint groupSize,
                      in uint nRepetitions, ref Xorshift rng) {
    uint eq = 0;

    foreach (immutable _; 0 .. nRepetitions) {
        uint[365] group;
        foreach (immutable __; 0 .. groupSize)
            group[uniform(0, $, rng)]++;
        eq += group[].any!(c => c >= nSharers);
    }

    return (eq * 100.0) / nRepetitions;
}

void main() {
    auto rng = 1.Xorshift; // Fixed seed.
    auto groupEst = 2;

    foreach (immutable sharers; 2 .. 6) {
        // Coarse.
        auto groupSize = groupEst + 1;
        while (equalBirthdays(sharers, groupSize, 100, rng) < 50.0)
            groupSize++;

        // Finer.
        immutable inf = to!int(groupSize - (groupSize - groupEst) / 4.0);
        foreach (immutable gs; inf .. groupSize + 999) {
            immutable eq = equalBirthdays(sharers, groupSize, 250, rng);
            if (eq > 50.0) {
                groupSize = gs;
                break;
            }
        }

        // Finest.
        foreach (immutable gs; groupSize - 1 .. groupSize + 999) {
            immutable eq = equalBirthdays(sharers, gs, 50_000, rng);
            if (eq > 50.0) {
                groupEst = gs;
                writefln("%d independent people in a group of %s share a common birthday. (%5.1f)",
                         sharers, gs, eq);
                break;
            }
        }
    }
}
