import std.stdio, std.range, std.algorithm, std.conv, arithmetic_rational;

auto bernoulli(in uint n) pure nothrow /*@safe*/ {
    auto A = new Rational[n + 1];
    foreach (immutable m; 0 .. n + 1) {
        A[m] = Rational(1, m + 1);
        foreach_reverse (immutable j; 1 .. m + 1)
            A[j - 1] = j * (A[j - 1] - A[j]);
    }
    return A[0];
}

void main() {
    immutable berns = 61.iota.map!bernoulli.enumerate.filter!(t => t[1]).array;
    immutable width = berns.map!(b => b[1].numerator.text.length).reduce!max;
    foreach (immutable b; berns)
        writefln("B(%2d) = %*d/%d", b[0], width, b[1].tupleof);
}
