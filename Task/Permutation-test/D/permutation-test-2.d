void main() @safe {
    import std.stdio, std.algorithm, std.range;

    immutable treatment = [85, 88, 75, 66, 25, 29, 83, 39, 97];
    immutable control = [68, 41, 10, 49, 16, 65, 32, 92, 28, 98];
    immutable both = treatment ~ control;
    immutable sTreat = treatment.sum;

    T pick(T)(in size_t at, in size_t remain, in T accu) pure nothrow @safe @nogc {
        if (remain == 0)
            return accu > sTreat;

        return pick(at - 1, remain - 1, accu + both[at - 1]) +
               (at > remain ? pick(at - 1, remain, accu) : 0);
    }

    alias mul = reduce!q{a * b};
    immutable t = mul(1.0, iota(both.length, treatment.length + 1, -1))
                  .reduce!q{a / b}(iota(treatment.length, 0, -1));
    immutable gt = pick(both.length, treatment.length, 0);
    immutable le = cast(int)(t - gt);
    writefln(" > : %2.2f%%  %d", 100.0 * gt / t, gt);
    writefln("<= : %2.2f%%  %d", 100.0 * le / t, le);
}
