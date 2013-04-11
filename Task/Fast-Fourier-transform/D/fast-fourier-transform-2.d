import std.stdio, std.math, std.algorithm, std.range, std.complex;

auto fft(Complex!real[] x)
{
    ulong N = x.length;
    if (N <= 1) { return x; }
    auto ev = stride(x, 2).array.fft;
    auto od = stride(x[1 .. $], 2).array.fft;
    auto l = map!(k => ev[k] + std.complex.expi(-2*PI*k/N) * od[k])(iota(N / 2));
    auto r = map!(k => ev[k] - std.complex.expi(-2*PI*k/N) * od[k])(iota(N / 2));
    return l.chain(r).array;
}

void main()
{
    // map produces range, .array converts range to array
    auto data = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0].map!(a => Complex!real(a, 0)).array;
    data.fft.writeln;
}
