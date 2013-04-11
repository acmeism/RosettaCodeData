import std.stdio, std.bigint, std.range, std.algorithm;

struct Filtered(R1, R2) if (is(ElementType!R1 == ElementType!R2)) {
    R1 s1;
    R2 s2;
    alias ElementType!R1 T;
    T current, source, filter;

    this(R1 r1, R2 r2) {
        s1 = r1;
        s2 = r2;
        source = s1.front();
        filter = s2.front();
        _next();
    }

    const bool empty = false;
    @property T front() { return current; }
    void popFront() { _next(); }

    private void _next() {
        while (true) {
            if (source > filter) {
                s2.popFront();
                filter = s2.front();
                continue;
            } else if (source < filter) {
                current = source;
                s1.popFront();
                source = s1.front();
                break;
            }
            s1.popFront();
            source = s1.front();
        }
    }
}

auto filtered(R1, R2)(R1 r1, R2 r2)
if (is(ElementType!R1 == ElementType!R2)) {
    return Filtered!(R1, R2)(r1, r2);
}

struct Count(T) {
    T n;
    const bool empty = false;
    @property T front() { return n; }
    void popFront() { /* n++; */ n += 1; }
}

Count!T count(T)(T start) { return Count!T(start); }
Count!T count(T)() { return Count!T(cast(T)0); }

void main() {
    auto squares = count!BigInt().map!q{a ^^ 2}();
    auto cubes = count!BigInt().map!q{a ^^ 3}();
    auto f = filtered(squares, cubes);

    popFrontN(f, 20);
    writeln(take(f, 10));
}
