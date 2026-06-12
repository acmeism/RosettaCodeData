use std::f64;

#[derive(Copy, Clone)]
struct Triple {
    m: f64,
    fm: f64,
    simp: f64,
}

/* "structured" adaptive version, translated from Racket */
fn _quad_simpsons_mem<F>(f: F, a: f64, fa: f64, b: f64, fb: f64) -> Triple
where
    F: Fn(f64) -> f64,
{
    // Evaluates Simpson's Rule, also returning m and f(m) to reuse.
    let m = (a + b) / 2.0;
    let fm = f(m);
    let simp = (b - a).abs() / 6.0 * (fa + 4.0 * fm + fb);
    Triple { m, fm, simp }
}

fn _quad_asr<F>(
    f: F,
    a: f64,
    fa: f64,
    b: f64,
    fb: f64,
    eps: f64,
    whole: f64,
    m: f64,
    fm: f64,
) -> f64
where
    F: Fn(f64) -> f64 + Copy,
{
    // Efficient recursive implementation of adaptive Simpson's rule.
    // Function values at the start, middle, end of the intervals are retained.
    let lt = _quad_simpsons_mem(f, a, fa, m, fm);
    let rt = _quad_simpsons_mem(f, m, fm, b, fb);
    let delta = lt.simp + rt.simp - whole;
    if delta.abs() <= eps * 15.0 {
        return lt.simp + rt.simp + delta / 15.0;
    }
    _quad_asr(f, a, fa, m, fm, eps / 2.0, lt.simp, lt.m, lt.fm)
        + _quad_asr(f, m, fm, b, fb, eps / 2.0, rt.simp, rt.m, rt.fm)
}

fn quad_asr<F>(f: F, a: f64, b: f64, eps: f64) -> f64
where
    F: Fn(f64) -> f64 + Copy,
{
    // Integrate f from a to b using ASR with max error of eps.
    let fa = f(a);
    let fb = f(b);
    let t = _quad_simpsons_mem(f, a, fa, b, fb);
    _quad_asr(f, a, fa, b, fb, eps, t.simp, t.m, t.fm)
}

fn main() {
    let a = 0.0;
    let b = 1.0;
    let sinx = quad_asr(f64::sin, a, b, 1e-09);
    println!(
        "Simpson's integration of sine from {} to {} = {}",
        a, b, sinx
    );
}
