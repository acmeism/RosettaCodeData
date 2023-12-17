fn perm(n: f64, k: f64) -> f64 {
    let mut result: f64 = 1.0;
    let mut i: f64 = 0.0;

    while i < k {
        result *= n - i;
        i += 1.0;
    }

    result
}

fn comb(n: f64, k: f64) -> f64 {
    perm(n, k) / perm(k, k)
}

fn main() {
    const P: f64 = 12.0;
    const C: f64 = 60.0;

    let mut j: f64 = 1.0;
    let mut k: f64 = 10.0;

    while j < P {
        println!("P({},{}) = {}", P, j, perm(P, j).floor());
        j += 1.0;
    }

    while k < C {
        println!("C({},{}) = {}", C, k, comb(C, k).floor());
        k += 10.0;
    }

}
