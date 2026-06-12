import "std/math.zc";
import "std/string.zc";

alias cheb_fn = fn*(f64) -> f64;

fn map_range(x: f64, min: f64, max: f64, min_to: f64, max_to: f64) -> f64 {
    return (x - min) / (max - min) * (max_to - min_to) + min_to;
}

fn cheb_coeffs(func: cheb_fn, n: int, min: f64, max: f64, coeffs: f64*) {
    for i in 0..n {
        let ii = (f64)i;
        let nn = (f64)n;
        let f = func(map_range(Math::cos(Math::PI() * (ii + 0.5) / nn), -1.0, 1.0, min, max));
        f = f * 2.0 / nn;
        for j in 0..n {
            let jj = (f64)j;
            coeffs[j] += f * Math::cos(Math::PI() * jj * (ii + 0.5) / nn);
        }
    }
}

fn cheb_approx(x: f64, n: int, min: f64, max: f64, coeffs: f64*) -> f64 {
    assert(n >= 2, "'n' can't be less than 2.";
    let a = 1.0;
    let b = map_range(x, min, max, -1.0, 1.0);
    let res = coeffs[0] / 2.0 + coeffs[1] * b;
    let xx = 2.0 * b;
    for i in 2..n {
        let c = xx * b - a;
        res += coeffs[i] * c;
        a = b;
        b = c;
    }
    return res;
}

fn cheb_func(x: f64)-> f64 { return Math::cos(x); }

fn main() {
    def N = 10;
    let min = 0.0;
    let max = 1.0;
    let coeffs: [f64; N];
    cheb_coeffs(cheb_func, N, min, max, coeffs);
    println "Coefficients:";
    for coeff in coeffs {
        let s = coeff >= 0 ? " ": "";
        println "{s}{coeff:1.14f}";
    }
    println "\nApproximations:\n  x      func(x)    approx       diff";
    for i in 0..=20 {
        let x = map_range((f64)i, 0.0, 20.0, min, max);
        let f = Math::cos(x);
        let approx = cheb_approx(x, N, min, max, coeffs);
        let diff = approx - f;
        let ds = String::from("{diff:g}");
        let len = ds.length();
        let e = ds.substring(len - 4, 4);
        let ds2 = ds.substring(0, len - 5);
        let ds3: String;
        if diff >= 0 {
            ds3 = ds2.substring(0, 4);
            ds3.insert_rune(0, ' ');
        } else {
            ds3 = ds2.substring(0, 5);
        }
        ds3.append(&e);
        println "{x:1.3f}  {f:1.8f} {approx:1.8f}  {ds3}";
    }
}
