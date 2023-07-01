fn compare_co9_efficiency(base: u64, upto: u64) {
    let naive_candidates: Vec<u64> = (1u64..upto).collect();
    let co9_candidates: Vec<u64> = naive_candidates.iter().cloned()
        .filter(|&x| x % (base - 1) == (x * x) % (base - 1))
        .collect();
    for candidate in &co9_candidates {
        print!("{} ", candidate);
    }
    println!();
    println!(
        "Trying {} numbers instead of {} saves {:.2}%",
        co9_candidates.len(),
        naive_candidates.len(),
        100.0 - 100.0 * (co9_candidates.len() as f64 / naive_candidates.len() as f64)
    );
}

fn main() {
    compare_co9_efficiency(10, 100);
    compare_co9_efficiency(16, 256);
}
