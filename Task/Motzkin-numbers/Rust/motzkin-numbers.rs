// [dependencies]
// primal = "0.3"
// num-format = "0.4"

fn motzkin(n: usize) -> Vec<usize> {
    let mut m = vec![0; n];
    m[0] = 1;
    m[1] = 1;
    for i in 2..n {
        m[i] = (m[i - 1] * (2 * i + 1) + m[i - 2] * (3 * i - 3)) / (i + 2);
    }
    m
}

fn main() {
    use num_format::{Locale, ToFormattedString};
    let count = 42;
    let m = motzkin(count);
    println!(" n          M(n)             Prime?");
    println!("-----------------------------------");
    for i in 0..count {
        println!(
            "{:2}  {:>23}  {}",
            i,
            m[i].to_formatted_string(&Locale::en),
            primal::is_prime(m[i] as u64)
        );
    }
}
