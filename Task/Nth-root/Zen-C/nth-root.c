def EPS = 2.220446e-016 * 10;

fn power(x: f64, e: int) -> f64 {
    let r = 1.0;
    for i in 0..e { r *= x; }
    return r;
}

fn root(n: int, x: f64) -> f64 {
    let d: f64;
    let r = 1.0;
    if n < 1 || (x < 0 && !(n & 1)) { return 0.0 / 0.0; } // NaN
    do {
        d = (x / power(r, n - 1) - r)  / n;
        r += d;
    } while d >= EPS || d <= -EPS;
    return r;
}

fn main()  {
    let n = 15;
    let x = power(-3.14159, 15);
    printf("root(%d, %g) = %g\n", n, x, root(n, x));
}
