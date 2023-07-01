import std.stdio, std.bigint, std.range, std.algorithm;

struct Filtered(R1, R2) if (is(ElementType!R1 == ElementType!R2)) {
    R1 s1;
    R2 s2;
    alias ElementType!R1 T;
    T front, source, filter;

    this(R1 r1, R2 r2) {
        s1 = r1;
        s2 = r2;
        source = s1.front;
        filter = s2.front;
        popFront;
    }

    static immutable empty = false;

    void popFront() {
        while (true) {
            if (source > filter) {
                s2.popFront;
                filter = s2.front;
                continue;
            } else if (source < filter) {
                front = source;
                s1.popFront;
                source = s1.front;
                break;
            }
            s1.popFront;
            source = s1.front;
        }
    }
}

auto filtered(R1, R2)(R1 r1, R2 r2) // Helper function.
if (isInputRange!R1 && isInputRange!R2 &&
    is(ElementType!R1 == ElementType!R2)) {
    return Filtered!(R1, R2)(r1, r2);
}

void main() {
    auto squares = 0.sequence!"n".map!(i => i.BigInt ^^ 2);
    auto cubes = 0.sequence!"n".map!(i => i.BigInt ^^ 3);
    filtered(squares, cubes).drop(20).take(10).writeln;
}
