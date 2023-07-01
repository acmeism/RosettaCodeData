import std.stdio, std.algorithm, std.range, std.math;

const(creal)[] fft(in creal[] x) pure /*nothrow*/ @safe {
    immutable N = x.length;
    if (N <= 1) return x;
    const ev = x.stride(2).array.fft;
    const od = x[1 .. $].stride(2).array.fft;
    auto l = iota(N / 2).map!(k => ev[k] + expi(-2*PI * k/N) * od[k]);
    auto r = iota(N / 2).map!(k => ev[k] - expi(-2*PI * k/N) * od[k]);
    return l.chain(r).array;
}

void main() @safe {
    [1.0L+0i, 1, 1, 1, 0, 0, 0, 0].fft.writeln;
}
