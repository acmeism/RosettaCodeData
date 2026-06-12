import std.stdio, std.random, std.math;

enum nDays = 365;

// 5 sigma confidence. Conventionally people think 3 sigmas are good
// enough, but for case of 5 people sharing birthday, 3 sigmas
// actually sometimes give a slightly wrong answer.
enum double nSigmas = 3.0; // Currently 3 for smaller run time.

/// Given n people, if m of them have same birthday in one run.
bool simulate1(in uint nPeople, in uint nCollisions, ref Xorshift rng)
/*nothrow*/ @safe /*@nogc*/ {
    static uint[nDays] days;
    days[] = 0;

    foreach (immutable _; 0 .. nPeople) {
        immutable day = uniform(0, days.length, rng);
        days[day]++;
        if (days[day] == nCollisions)
            return true;
    }
    return false;
}

/** Decide if the probablity of n out of np people sharing a birthday
is above or below pThresh, with nSigmas sigmas confidence.
If pThresh is very low or hi, minimum runs need to be much higher. */
double prob(in uint np, in uint nCollisions, in double pThresh,
            out double stdDev, ref Xorshift rng) {
    double p, d; // Probablity and standard deviation.
    uint nRuns = 0, yes = 0;

    do {
        yes += simulate1(np, nCollisions, rng);
        nRuns++;
        p = double(yes) / nRuns;
        d = sqrt(p * (1 - p) / nRuns);
        debug if (yes % 50_000 == 0)
            printf("\t\t%d: %d %d %g %g        \r", np, yes, nRuns, p, d);
    } while (nRuns < 10 || abs(p - pThresh) < (nSigmas * d));

    debug '\n'.putchar;

    stdDev = d;
    return p;
}

/// Bisect for truth.
uint findHalfChance(in uint nCollisions, out double p, out double dev, ref Xorshift rng) {
    uint mid;

    RESET:
    uint lo = 0;
    uint hi = nDays * (nCollisions - 1) + 1;

    do {
        mid = (hi + lo) / 2;
        p = prob(mid, nCollisions, 0.5, dev, rng);

        debug printf("\t%d %d %d %g %g\n", lo, mid, hi, p, dev);

        if (p < 0.5)
            lo = mid + 1;
        else
            hi = mid;

        if (hi < lo) {
            // This happens when previous precisions were too low;
            // easiest fix: reset.
            debug "\tMade a mess, will redo.".puts;
            goto RESET;
        }
    } while (lo < mid || p < 0.5);

    return mid;
}

void main() {
    auto rng = Xorshift(unpredictableSeed);

    foreach (immutable uint nCollisions; 2 .. 6) {
        double p, d;
        immutable np = findHalfChance(nCollisions, p, d, rng);
        writefln("%d collision: %d people, P = %g +/- %g", nCollisions, np, p, d);
    }
}
