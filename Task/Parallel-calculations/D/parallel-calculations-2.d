import std.stdio, std.math, std.algorithm, std.typecons,
       core.thread, core.stdc.time;

final class MinFactor: Thread {
    private immutable ulong num;
    private ulong[] fac;
    private ulong minFac;

    this(in ulong n) /*pure nothrow*/ {
        super(&run);
        num = n;
        fac = new ulong[0];
    }

    @property ulong number() const pure nothrow {
        return num;
    }

    @property const(ulong[]) factors() const pure nothrow {
        return fac;
    }

    @property ulong minFactor() const pure nothrow {
        return minFac;
    }

    private void run() {
        immutable clock_t begin = clock();
        switch (num) {
            case 0: fac = []; break;

            case 1: fac = [1]; break;

            default:
                uint limit = cast(uint)(1 + sqrt(cast(double)num));
                ulong n = num;
                for (ulong divi = 3; divi < limit; divi += 2) {
                    if (n == 1)
                        break;
                    if ((n % divi) == 0) {
                        while ((n > 1) && ((n % divi) == 0)) {
                            fac ~= divi;
                            n /= divi;
                        }
                        limit = cast(uint)(1 + sqrt(cast(double)n));
                    }
                }
                if (n > 1)
                    fac ~= n;
        }
        minFac = reduce!min(fac);
        immutable clock_t end = clock();
        writefln("num: %20d --> min. factor: %20d  ticks(%7d -> %7d)",
                 num, minFac, begin, end);
    }
}

void main() {
    immutable ulong[] numbers = [
        2UL^^59-1, 2UL^^59-1, 2UL^^59-1, 112_272_537_195_293UL,
        115_284_584_522_153, 115_280_098_190_773,
        115_797_840_077_099, 112_582_718_962_171,
        112_272_537_095_293, 1_099_726_829_285_419];

    auto tGroup = new ThreadGroup;
    foreach (n; numbers)
        tGroup.add(new MinFactor(n));

    writeln("Minimum factors for respective numbers are:");
    foreach (t; tGroup)
        t.start();
    tGroup.joinAll();

    auto maxMin = tuple(0UL, [0UL], 0UL);
    foreach (thread; tGroup) {
        auto s = cast(MinFactor)thread;
        if (s !is null && maxMin[2] < s.minFactor)
            maxMin = tuple(s.number, s.factors.dup, s.minFactor);
    }

    writefln("Number with largest min. factor is %16d," ~
             " with factors:\n\t%s", maxMin.tupleof);
}
