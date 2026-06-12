import std.stdio, std.array, std.concurrency;

Generator!(T[]) permutationsWithRepetitions(T)(T[] data, in uint n)
in {
    assert(!data.empty && n > 0);
} body {
    return new typeof(return)({
        if (n == 1) {
            foreach (el; data)
                yield([el]);
        } else {
            foreach (el; data)
                foreach (perm; permutationsWithRepetitions(data, n - 1))
                    yield(el ~ perm);
        }
    });
}

void main() {
    [1, 2, 3].permutationsWithRepetitions(2).writeln;
}
