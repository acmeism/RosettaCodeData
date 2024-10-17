use std::{collections::HashSet, fs};

fn reverse(x: &str) -> String {
    x.chars().rev().collect::<String>()
}

fn main() {
    let content = fs::read_to_string("unixdict.txt").expect("No file found!");
    let work: HashSet<&str> = content.lines().collect();

    let mut candidats: Vec<&str> = work.clone().into_iter().collect();
    candidats.retain(|&x| work.contains(&reverse(x).as_str()) && x < reverse(x).as_str());

    println!("Numbers of pairs found: {}", candidats.len());
    for ind in 0..5 {
        println!("{}, {}", candidats[ind], reverse(candidats[ind]));
    }
}
