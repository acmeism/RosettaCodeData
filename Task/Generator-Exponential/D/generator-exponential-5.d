import std.stdio, std.range, std.algorithm, std.concurrency, std.bigint;

auto powers(in uint m) pure nothrow @safe {
    return 0.sequence!"n".map!(i => i.BigInt ^^ m);
}

auto filtered(R1, R2)(R1 r1, R2 r2) /*@safe*/
if (isForwardRange!R1 && isForwardRange!R2 &&
    is(ElementType!R1 == ElementType!R2)) {
    return new Generator!(ElementType!R1)({
        auto v = r1.front; r1.popFront;
        auto f = r2.front; r2.popFront;

        while (true) {
            if (v > f) {
                f = r2.front; r2.popFront;
                continue;
            } else if (v < f)
                yield(v);
            v = r1.front; r1.popFront;
        }
    });
}

void main() {
    auto squares = 2.powers, cubes = 3.powers;
    filtered(squares, cubes).drop(20).take(10).writeln;
}
