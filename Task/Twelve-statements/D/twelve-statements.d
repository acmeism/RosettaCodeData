import std.stdio, std.typecons, std.algorithm,std.range,std.functional;

immutable texts = [
    "this is a numbered list of twelve statements",
    "exactly 3 of the last 6 statements are true",
    "exactly 2 of the even-numbered statements are true",
    "if statement 5 is true, then statements 6 and 7 are both true",
    "the 3 preceding statements are all false",
    "exactly 4 of the odd-numbered statements are true",
    "either statement 2 or 3 is true, but not both",
    "if statement 7 is true, then 5 and 6 are both true",
    "exactly 3 of the first 6 statements are true",
    "the next two statements are both true",
    "exactly 1 of statements 7, 8 and 9 are true",
    "exactly 4 of the preceding statements are true"];

alias curry!(reduce!q{a + b}, 0) sumi;

immutable bool function(in bool[])[] funcs = [
    s => s.length == 12,
    s => sumi(s[$-6 .. $]) == 3,
    s => sumi(s[1 .. $].stride(2)) == 2,
    s => s[4] ? (s[5] && s[6]) : true,
    s => sumi(s[1 .. 4]) == 0,
    s => sumi(s[0 .. $].stride(2)) == 4,
    s => sumi(s[1 .. 3]) == 1,
    s => s[6] ? (s[4] && s[5]) : true,
    s => sumi(s[0 .. 6]) == 3,
    s => s[10] && s[11],
    s => sumi(s[6 .. 9]) == 1,
    s => sumi(s[0 .. 11]) == 4];

void main() {
    enum nStats = 12;
    Tuple!(const bool[], const bool[])[] full, partial;

    foreach (n; 0 .. 2 ^^ nStats) {
        const st = iota(nStats).map!(i => !!(n & (2 ^^ i)))().array();
        auto truths = funcs.map!(f => f(st))();
        const matches = zip(st, truths)
                        .map!(s_t => s_t[0] == s_t[1])()
                        .array();
        immutable mCount = matches.sumi();
        if (mCount == nStats)
            full ~= tuple(st, matches);
        else if (mCount == nStats - 1)
            partial ~= tuple(st, matches);
    }

    foreach (sols, isPartial; zip([full, partial], [false, true]))
        foreach (stm; sols) {
            if (isPartial) {
                immutable pos = stm[1].countUntil(false);
                writefln(`Missed by statement %d: "%s"`,
                         pos + 1, texts[pos]);
            } else
                writeln("Solution:");
            write("  ");
            foreach (i, t; stm[0])
                writef("%d:%s  ", i + 1, t ? "T" : "F");
            writeln();
        }
}
