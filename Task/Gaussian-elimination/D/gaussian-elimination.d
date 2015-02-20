import std.stdio, std.math, std.algorithm, std.range, std.numeric,
       std.typecons;

Tuple!(double[],"x", string,"err")
gaussPartial(in double[][] a0, in double[] b0) pure /*nothrow*/
in {
    assert(a0.length == a0[0].length);
    assert(a0.length == b0.length);
    assert(a0.all!(row => row.length == a0[0].length));
} body {
    enum eps = 1e-6;
    immutable m = b0.length;

    // Make augmented matrix.
    //auto a = a0.zip(b0).map!(c => c[0] ~ c[1]).array; // Not mutable.
    auto a = a0.zip(b0).map!(c => [] ~ c[0] ~ c[1]).array;

    // Wikipedia algorithm from Gaussian elimination page,
    // produces row-eschelon form.
    foreach (immutable k; 0 .. a.length) {
        // Find pivot for column k and swap.
        a[k .. m].minPos!((x, y) => x[k] > y[k]).front.swap(a[k]);
        if (a[k][k].abs < eps)
            return typeof(return)(null, "singular");

        // Do for all rows below pivot.
        foreach (immutable i; k + 1 .. m) {
            // Do for all remaining elements in current row.
            a[i][k+1 .. m+1] -= a[k][k+1 .. m+1] * (a[i][k] / a[k][k]);

            a[i][k] = 0; // Fill lower triangular matrix with zeros.
        }
    }

    // End of WP algorithm. Now back substitute to get result.
    auto x = new double[m];
    foreach_reverse (immutable i; 0 .. m)
        x[i] = (a[i][m] - a[i][i+1 .. m].dotProduct(x[i+1 .. m])) / a[i][i];

    return typeof(return)(x, null);
}

void main() {
    // The test case result is correct to this tolerance.
    enum eps = 1e-13;

    // Common RC example. Result computed with rational arithmetic
    // then converted to double, and so should be about as close to
    // correct as double represention allows.
    immutable a = [[1.00, 0.00, 0.00,  0.00,  0.00,   0.00],
                   [1.00, 0.63, 0.39,  0.25,  0.16,   0.10],
                   [1.00, 1.26, 1.58,  1.98,  2.49,   3.13],
                   [1.00, 1.88, 3.55,  6.70, 12.62,  23.80],
                   [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
                   [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]];
    immutable b = [-0.01, 0.61, 0.91,  0.99,  0.60,   0.02];

    immutable r = gaussPartial(a, b);
    if (!r.err.empty)
        return writeln("Error: ", r.err);
    r.x.writeln;

    immutable result = [-0.01,               1.602790394502114,
                        -1.6132030599055613, 1.2454941213714368,
                        -0.4909897195846576, 0.065760696175232];
    foreach (immutable i, immutable xi; result)
        if (abs(r.x[i] - xi) > eps)
            return writeln("Out of tolerance: ", r.x[i], " ", xi);
}
