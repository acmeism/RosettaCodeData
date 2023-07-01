import std.range;
import std.stdio;

struct TM {
    private char[] sequence = ['0'];
    private char[] inverse = ['1'];
    private char[] buffer;

    enum empty = false;

    auto front() {
        return sequence;
    }

    auto popFront() {
        buffer = sequence;
        sequence ~= inverse;
        inverse ~= buffer;
    }
}

void main() {
    TM sequence;

    foreach (step; sequence.take(8)) {
        writeln(step);
    }
}
