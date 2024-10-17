use std::fs::File;
use std::io::{Read, BufReader};

fn entropy<I: IntoIterator<Item = u8>>(iter: I) -> f32 {
    let mut histogram = [0u64; 256];
    let mut len = 0u64;

    for b in iter {
        histogram[b as usize] += 1;
        len += 1;
    }

    histogram
        .iter()
        .cloned()
        .filter(|&h| h > 0)
        .map(|h| h as f32 / len as f32)
        .map(|ratio| -ratio * ratio.log2())
        .sum()
}

fn main() {
    let name = std::env::args().nth(0).expect("Could not get program name.");
    let file = BufReader::new(File::open(name).expect("Could not read file."));
    println!("Entropy is {}.", entropy(file.bytes().flatten()));
}
