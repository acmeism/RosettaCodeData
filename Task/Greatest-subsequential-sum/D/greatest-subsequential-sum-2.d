import std.stdio, std.algorithm, std.range, std.typecons;

mixin template InitsTails(T) {
    T[] data;
    size_t pos;
    @property bool empty() pure nothrow {
        return pos > data.length;
    }
    void popFront() pure nothrow { pos++; }
}

struct Inits(T) {
    mixin InitsTails!T;
    @property T[] front() pure nothrow { return data[0 .. pos]; }
}

auto inits(T)(T[] seq) { return seq.Inits!T; }

struct Tails(T) {
    mixin InitsTails!T;
    @property T[] front() pure nothrow { return data[pos .. $]; }
}

auto tails(T)(T[] seq) pure nothrow { return seq.Tails!T; }

T[] maxSubseq(T)(T[] seq) pure nothrow {
    //return seq.tails.map!inits.join.reduce!(max!sum);
    return reduce!max(tuple(0, T[].init),
                      seq
                      .tails
                      .map!inits
                      .join
                      .map!q{ tuple(reduce!q{a + b}(0, a), a) }
                      )[1];
}

void main() {
    [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1].maxSubseq.writeln;
    [-1, -2, -3, -5, -6, -2, -1, -4, -4, -2, -1].maxSubseq.writeln;
}
