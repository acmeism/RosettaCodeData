use std::f64;

fn aitken(f: fn(f64) -> f64, p0: f64) -> f64 {
    let p1 = f(p0);
    let p2 = f(p1);
    let p1m0 = p1 - p0;
    p0 - p1m0 * p1m0 / (p2 - 2.0 * p1 + p0)
}

fn steffensen_aitken(f: fn(f64) -> f64, pinit: f64, tol: f64, maxiter: i32) -> f64 {
    let mut p0 = pinit;
    let mut p = aitken(f, p0);
    let mut iter = 1;
    while (p - p0).abs() > tol && iter < maxiter {
        p0 = p;
        p = aitken(f, p0);
        iter += 1;
    }
    if (p - p0).abs() > tol {
        f64::NAN
    } else {
        p
    }
}

fn de_casteljau(c0: f64, c1: f64, c2: f64, t: f64) -> f64 {
    let s = 1.0 - t;
    let c01 = s * c0 + t * c1;
    let c12 = s * c1 + t * c2;
    s * c01 + t * c12
}

fn x_convex_left_parabola(t: f64) -> f64 {
    de_casteljau(2.0, -8.0, 2.0, t)
}

fn y_convex_right_parabola(t: f64) -> f64 {
    de_casteljau(1.0, 2.0, 3.0, t)
}

fn implicit_equation(x: f64, y: f64) -> f64 {
    5.0 * x * x + y - 5.0
}

fn f(t: f64) -> f64 {
    let x = x_convex_left_parabola(t);
    let y = y_convex_right_parabola(t);
    implicit_equation(x, y) + t
}

fn main() {
    let mut t0 = 0.0;
    for _i in 0..11 {
        print!("t0 = {:.1} : ", t0);
        let t = steffensen_aitken(f, t0, 0.00000001, 1000);
        if t.is_nan() {
            println!("no answer");
        } else {
            let x = x_convex_left_parabola(t);
            let y = y_convex_right_parabola(t);
            if implicit_equation(x, y).abs() <= 0.000001 {
                println!("intersection at ({}, {})", x, y);
            } else {
                println!("spurious solution");
            }
        }
        t0 += 0.1;
    }
}
