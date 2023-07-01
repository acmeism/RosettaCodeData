fn main() {
    for num in fibonacci_sequence() {
        println!("{}", num);
    }
}

fn fibonacci_sequence() -> impl Iterator<Item = u64> {
    let sqrt_5 = 5.0f64.sqrt();
    let p = (1.0 + sqrt_5) / 2.0;
    let q = 1.0 / p;
    // The range is sufficient up to 70th Fibonacci number
    (0..1).chain((1..70).map(move |n| ((p.powi(n) + q.powi(n)) / sqrt_5 + 0.5) as u64))
}
