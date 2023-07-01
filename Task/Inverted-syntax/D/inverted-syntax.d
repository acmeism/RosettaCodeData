#!/usr/bin/rdmd

import std.algorithm;

void main() {
    assert("Hello, World".length == 12);
    assert("Cleanliness".startsWith("Clean"));

    auto r = [1, 4, 2, 8, 5, 7]
        .filter!(n => n > 2)
        .map!(n => n * 2);

    assert(r.equal([8, 16, 10, 14]));
}
