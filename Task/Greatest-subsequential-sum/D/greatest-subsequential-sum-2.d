import std.stdio, std.algorithm, std.range, std.typecons;

mixin template InitsTails(T) {
    T[] data;
    size_t pos;
    @property bool empty() { return pos > data.length; }
    void popFront() { pos++; }
}

struct Inits(T) {
    mixin InitsTails!T;
    @property T[] front() { return data[0 .. pos]; }
}

auto inits(T)(T[] seq) { return seq.Inits!T; }

struct Tails(T) {
    mixin InitsTails!T;
    @property T[] front() { return data[pos .. $]; }
}

auto tails(T)(T[] seq) { return seq.Tails!T; }

auto maxSubseq(T)(T[] seq) /*pure nothrow*/ {
    //return seq.tails.map!inits.join.reduce!(max!q{ a.sum });
    return seq
           .tails
           .map!inits
           .join
           .map!q{ tuple(reduce!q{a + b}(0, a), a) }
           .reduce!max[1];
}

void main() {
    [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1].maxSubseq.writeln;
    [-1, -2, -3, -5, -6, -2, -1, -4, -4, -2, -1].maxSubseq.writeln;
}
