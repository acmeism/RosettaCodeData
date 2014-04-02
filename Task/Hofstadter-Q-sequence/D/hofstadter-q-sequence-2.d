import std.stdio, std.algorithm, std.range, std.array;

struct Q {
    __gshared static Appender!(uint[]) s;

    nothrow static this() {
        s ~= [0, 1, 1];
    }

    static uint opCall(in int n) nothrow
    in {
        assert(n > 0);
    } body {
        foreach (immutable i; s.data.length .. n + 1)
            s ~= s.data[i - s.data[i - 1]] + s.data[i - s.data[i - 2]];
        return s.data[n];
    }
}

void main() {
    writeln("Q(n) for n = [1..10] is: ", iota(1, 11).map!Q);
    writeln("Q(1000) = ", Q(1000));
    writefln("Q(i) is less than Q(i-1) for i [2..100_000] %d times.",
             iota(2, 100_001).count!(i => Q(i) < Q(i - 1)));
}
