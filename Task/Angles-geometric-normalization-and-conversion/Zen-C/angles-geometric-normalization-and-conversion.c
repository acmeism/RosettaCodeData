import "std/math.zc"

fn d2d(d: f64) -> f64 { return Math::mod(d, 360.0); }
fn g2g(g: f64) -> f64 { return Math::mod(g, 400.0); }
fn m2m(m: f64) -> f64 { return Math::mod(m, 6400.0); }
fn r2r(r: f64) -> f64 { return Math::mod(r, 2.0 * Math::PI()); }
fn d2g(d: f64) -> f64 { return d2d(d) * 400.0 / 360.0; }
fn d2m(d: f64) -> f64 { return d2d(d) * 6400.0 / 360.0; }
fn d2r(d: f64) -> f64 { return d2d(d) * Math::PI() / 180.0; }
fn g2d(g: f64) -> f64 { return g2g(g) * 360.0 / 400.0; }
fn g2m(g: f64) -> f64 { return g2g(g) * 6400.0 / 400.0; }
fn g2r(g: f64) -> f64 { return g2g(g) * Math::PI() / 200.0; }
fn m2d(m: f64) -> f64 { return m2m(m) * 360.0 / 6400.0; }
fn m2g(m: f64) -> f64 { return m2m(m) * 400.0 / 6400.0; }
fn m2r(m: f64) -> f64 { return m2m(m) * Math::PI() / 3200.0; }
fn r2d(r: f64) -> f64 { return r2r(r) * 180.0 / Math::PI(); }
fn r2g(r: f64) -> f64 { return r2r(r) * 200.0 / Math::PI(); }
fn r2m(r: f64) -> f64 { return r2r(r) * 3200 / Math::PI(); }

fn main() {
    let f1 = "%15s %15s %15s %15s %15s\n";
    let f2 = "%15.7f %15.7f %15.7f %15.7f %15.7f\n";
    let angles: f64[12] = [-2.0, -1.0, 0.0, 1.0, 2.0, 6.2831853, 16.0, 57.2957795, 359.0, 399.0, 6399.0, 1000000.0];

    printf(f1, "degrees", "norm degs", "gradians", "mils", "radians");
    for a in angles {
        printf(f2, a, d2d(a), d2g(a), d2m(a), d2r(a));
    }
    println "";

    printf(f1, "gradians", "norm grds", "degrees", "mils", "radians");
    for a in angles {
        printf(f2, a, g2g(a), g2d(a), g2m(a), g2r(a));
    }
    println "";

    printf(f1, "mils", "norm mils", "degrees", "gradians", "radians");
    for a in angles {
        printf(f2, a, m2m(a), m2d(a), m2g(a), m2r(a));
    }
    println "";

    printf(f1, "radians", "norm rads", "degrees", "gradians", "mils");
    for a in angles {
        printf(f2, a, r2r(a), r2d(a), r2g(a), r2m(a));
    }
}
