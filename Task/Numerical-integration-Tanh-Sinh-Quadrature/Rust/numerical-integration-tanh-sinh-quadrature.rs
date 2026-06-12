use std::f64::consts::PI;

/// Tanh–Sinh numerical integration.
///
/// * `f`      – integrand
/// * `lower`  – lower integration bound
/// * `upper`  – upper integration bound
/// * `steps`  – maximum refinement levels
/// * `acc`    – absolute accuracy goal
///
/// Returns the estimated integral of `f` from `lower` to `upper`.
fn tanh_sinh<F>(mut f: F, lower: f64, upper: f64, steps: usize, acc: f64) -> f64
where
    F: FnMut(f64) -> f64,
{
    let h = 0.1;
    let h0 = (upper - lower) / 2.0;
    let h1 = (lower + upper) / 2.0;

    let mut rr = 0.0;

    for k in 1..=steps {
        let ro = rr;
        let n = (1 << k) - 1;

        let mut ss = 0.0;
        for i in (-n..=n).map(|i| i as f64) {
            let t = i * h;
            let sh = t.sinh();
            let ch = t.cosh();
            let th = (sh * PI / 2.0).tanh();
            let dx = (ch * PI / 2.0) / (sh * PI / 2.0).cosh().powi(2);
            let xi = h1 + h0 * th;
            let wt = h * dx;
            ss += f(xi) * wt;
        }

        rr = h0 * ss;
        if (rr - ro).abs() < acc {
            break;
        }
    }

    rr
}

fn main() {
    let res = tanh_sinh(|x| x.sin(), 0.0, 1.0, 5, 1e-8);
    println!("{:.8}", res);

    let res = tanh_sinh(|x| x.exp(), -3.0, 3.0, 5, 1e-8);
    println!("{:.8}", res);
}
