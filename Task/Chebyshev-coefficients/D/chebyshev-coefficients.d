import std.math: PI, cos;

/// Map x from range [min, max] to [min_to, max_to].
real map(in real x, in real min_x, in real max_x, in real min_to, in real max_to)
pure nothrow @safe @nogc {
	return (x - min_x) / (max_x - min_x) * (max_to - min_to) + min_to;
}


void chebyshevCoef(size_t N)(in real function(in real) pure nothrow @safe @nogc func,
                             in real min, in real max, ref real[N] coef)
pure nothrow @safe @nogc {
    coef[] = 0.0;

    foreach (immutable i; 0 .. N) {
        immutable f = func(map(cos(PI * (i + 0.5f) / N), -1, 1, min, max)) * 2 / N;
        foreach (immutable j, ref cj; coef)
            cj += f * cos(PI * j * (i + 0.5f) / N);
	}
}


/// f(x) = sum_{k=0}^{n - 1} c_k T_k(x) - c_0/2
real chebyshevApprox(size_t N)(in real x, in real min, in real max, in ref real[N] coef)
pure nothrow @safe @nogc if (N >= 2) {
    real a = 1.0L,
         b = map(x, min, max, -1, 1),
         result = coef[0] / 2 + coef[1] * b;

	immutable x2 = 2 * b;
    foreach (immutable ci; coef[2 .. $]) {
		// T_{n+1} = 2x T_n - T_{n-1}
        immutable c = x2 * b - a;
        result += ci * c;
        a = b;
        b = c;
    }

    return result;
}


void main() @safe {
    import std.stdio: writeln, writefln;
    enum uint N = 10;

	real[N] c;
    real min = 0, max = 1;
    static real test(in real x) pure nothrow @safe @nogc { return x.cos; }
	chebyshevCoef(&test, min, max, c);

    writefln("Coefficients:\n%(  %+2.25g\n%)", c);

    enum nX = 20;
	writeln("\nApproximation:\n    x       func(x)        approx      diff");
    foreach (immutable i; 0 .. nX) {
        immutable x = map(i, 0, nX, min, max);
		immutable f = test(x);
		immutable approx = chebyshevApprox(x, min, max, c);

		writefln("%1.3f % 10.10f % 10.10f % 4.2e", x, f, approx, approx - f);
	}
}
