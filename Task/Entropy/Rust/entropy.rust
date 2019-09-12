fn entropy(s: &[u8]) -> f32 {
    let mut histogram = [0u64; 256];

    for &b in s {
        histogram[b as usize] += 1;
    }

    histogram
        .iter()
        .cloned()
        .filter(|&h| h != 0)
        .map(|h| h as f32 / s.len() as f32)
        .map(|ratio| -ratio * ratio.log2())
        .sum()
}

fn main() {
    let arg = std::env::args().nth(1).expect("Need a string.");
    println!("Entropy of {} is {}.", arg, entropy(arg.as_bytes()));
}
