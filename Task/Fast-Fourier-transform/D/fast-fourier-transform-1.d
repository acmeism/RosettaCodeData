import std.stdio, std.math, std.algorithm, std.range;

/*auto*/ creal[] fft(/*in*/ creal[] x) /*pure nothrow*/ {
    int N = x.length;
    if (N <= 1) return x;
    auto ev = stride(x, 2).array().fft();
    auto od = stride(x[1 .. $], 2).array().fft();
    auto l = map!(k => ev[k] + expi(-2*PI*k/N) * od[k])(iota(N / 2));
    auto r = map!(k => ev[k] - expi(-2*PI*k/N) * od[k])(iota(N / 2));
    return l.chain(r).array();
}

void main() {
    writeln(fft([1.0L+0i, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]));
}
