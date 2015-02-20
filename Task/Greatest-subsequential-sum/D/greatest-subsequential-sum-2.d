import std.stdio, std.algorithm, std.range, std.typecons;

mixin template InitsTails(T) {
    T[] data;
    size_t pos;
    @property bool empty() pure nothrow @nogc {
        return pos > data.length;
    }
    void popFront() pure nothrow @nogc { pos++; }
}

struct Inits(T) {
    mixin InitsTails!T;
    @property T[] front() pure nothrow @nogc { return data[0 .. pos]; }
}

auto inits(T)(T[] seq) pure nothrow @nogc { return seq.Inits!T; }

struct Tails(T) {
    mixin InitsTails!T;
    @property T[] front() pure nothrow @nogc { return data[pos .. $]; }
}

auto tails(T)(T[] seq) pure nothrow @nogc { return seq.Tails!T; }

T[] maxSubseq(T)(T[] seq) pure nothrow /*@nogc*/ {
    //return seq.tails.map!inits.joiner.reduce!(max!sum);
    return seq.tails.map!inits.join.minPos!q{ a.sum > b.sum }[0];
}

void main() {
    [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1].maxSubseq.writeln;
    [-1, -2, -3, -5, -6, -2, -1, -4, -4, -2, -1].maxSubseq.writeln;
}
