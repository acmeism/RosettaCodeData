use std::{collections::HashSet, fs};

fn reverse(x: &str) -> String {
    x.chars().rev().collect::<String>()
}

fn main() {
    let content = fs::read_to_string("unixdict.txt").expect("No file found!");
    let work: HashSet<&str> = content.lines().collect();

    let mut candidates: Vec<&str> = work.iter().copied().collect();
    candidates.retain(|&x| work.contains(&reverse(x).as_str()) && x < reverse(x).as_str());

    println!("Numbers of pairs found: {}", candidates.len());
    for candidate in candidates.iter().take(5) {
        println!("{}, {}", candidate, reverse(candidate));
    }
}
