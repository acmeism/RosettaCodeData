import std.stdio, std.algorithm, std.range, std.math, std.complex;

auto fft(T)(in T[] x) /*pure nothrow*/ {
    immutable N = x.length;
    if (N <= 1) return x;
    const ev = x.stride(2).array.fft;
    const od = x[1 .. $].stride(2).array.fft;
    alias E = std.complex.expi;
    auto l = iota(N / 2).map!(k=> ev[k] + cast(T)E(-2*PI*k/N) * od[k]);
    auto r = iota(N / 2).map!(k=> ev[k] - cast(T)E(-2*PI*k/N) * od[k]);
    return l.chain(r).array;
}

void main() {
    [1.0, 1, 1, 1, 0, 0, 0, 0].map!complex.array.fft.writeln;
}
