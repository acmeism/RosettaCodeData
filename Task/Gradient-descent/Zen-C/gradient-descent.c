import "std/math.zc"

// Function for which minimum is to be found.
fn g(x: f64*) -> f64 {
    return (x[0] - 1) * (x[0] - 1) *
        Math::exp(-x[1] * x[1]) + x[1] * (x[1] + 2) *
        Math::exp(-2 * x[0] * x[0]);
}

// Provides a rough calculation of gradient g(p).
fn gradG(p: f64*, z: f64*) {
    let x = p[0];
    let y = p[1];
    z[0] = 2 * (x - 1) * Math::exp(-y * y) - 4 * x * Math::exp(-2 * x * x) * y * (y + 2);
    z[1] = -2 * (x - 1) * (x - 1) * y * Math::exp(-y * y) + Math::exp(-2 * x * x) * (y + 2) + Math::exp(-2 * x * x) * y;
}

fn steepest_descent(x: f64*, n: const usize, alpha: f64, tol: f64) {
    let g0 = g(x);  // Initial estimate of result.

    // Calculate initial gradient.
    autofree let fi = (f64*)malloc(n * sizeof(f64));
    gradG(x, fi);

    // Calculate initial norm.
    let delG = 0.0;
    for i in 0..n { delG += fi[i] * fi[i]; }
    delG = Math::sqrt(delG);
    let b = alpha / delG;

    // Iterate until value is <= tolerance.
    while delG > tol {
        // Calculate next value.
        for i in 0..n { x[i] -= b * fi[i]; }

        // Calculate next gradient.
        gradG(x, fi);

        // Calculate next norm.
        delG = 0;
        for i in 0..n { delG += fi[i] * fi[i]; }
        delG = Math::sqrt(delG);
        b = alpha / delG;

        // Calculate next value.
        let g1 = g(x);

        // Adjust parameter.
        if g1 > g0 {
            alpha /= 2;
        } else {
            g0 = g1;
        }
    }
}

fn main() {
    let tol = 0.0000006;
    let alpha = 0.1;
    let x = [0.1, -1.0]; // Initial guess of location of minimum.
    steepest_descent(x, x.len, alpha, tol);
    println "Testing steepest descent method:";
    println "The minimum is at x = {x[0]}, y = {x[1]} for which f(x, y) = {g(x)}."
}
