// 20220322 Rust programming solution

fn gamma(N: u32) -> f64 { // Vacca series https://w.wiki/4ybp

    return 1f64 / 2f64 - 1f64 / 3f64
        + ((2..=N).map(|n| {
            let power: u32 = 2u32.pow(n);
            let mut sign: f64 = -1f64;
            let mut term: f64 = 0f64;

            for denominator in power..=(2 * power - 1) {
                sign *= -1f64;
                term += sign / f64::from(denominator);
            }

            return f64::from(n) * term;
        }))
        .sum::<f64>();
}

fn main() {
    println!("{}", gamma(23));
}
