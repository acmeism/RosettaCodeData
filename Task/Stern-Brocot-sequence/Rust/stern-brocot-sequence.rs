use gcd::Gcd;

fn stern_brocot(up_to: u64) -> Vec<u64> {
    let mut seq = vec![1_u64, 1];
    let mut last = 1_u64;
    let mut idx = 1_usize;
    while last < up_to {
        last = seq[idx];
        seq.push(last + seq[idx - 1]);
        seq.push(last);
        idx += 1;
    }
    seq
}

fn test_stern_brocot() {
    let seq = stern_brocot(100);
    println!("First 15 in sequence: {:?}", &seq[0..15]);
    println!("First positions of integers 1 through 10:");
    for i in 1..=10 {
        match seq.iter().position(|n| *n == i) {
            Some(idx) => println!("    {:>2} at position {}", i, idx + 1),
            _ => eprintln!("Error finding position of {}", i),
        }
    }
    println!(
        "   100 at position {}",
        seq.iter().position(|n| *n == 100).unwrap_or(0) + 1
    );
    println!(
        "The first 999 consecutive pairs have gcd of 1: {}.",
        (1..1000).all(|i| seq[i - 1].gcd(seq[i]) == 1)
    );
}

fn main() {
    test_stern_brocot();
}
