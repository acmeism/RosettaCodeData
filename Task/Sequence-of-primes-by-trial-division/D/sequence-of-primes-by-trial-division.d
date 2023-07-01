import std.stdio, std.range, std.algorithm, std.traits,
       std.numeric, std.concurrency;

Generator!(ForeachType!R) nubBy(alias pred, R)(R items) {
    return new typeof(return)({
        ForeachType!R[] seen;

        OUTER: foreach (x; items) {
            foreach (y; seen)
                if (pred(x, y))
                    continue OUTER;
            yield(x);
            seen ~= x;
        }
    });
}

void main() /*@safe*/ {
    sequence!q{n + 2}
    .nubBy!((x, y) => gcd(x, y) > 1)
    .take(20)
    .writeln;
}
