use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};
use std::iter::FromIterator;

fn semordnilap(filename: &str) -> std::io::Result<()> {
    let file = File::open(filename)?;
    let mut seen = HashSet::new();
    let mut count = 0;
    for line in io::BufReader::new(file).lines() {
        let mut word = line?;
        word.make_ascii_lowercase();
        let rev = String::from_iter(word.chars().rev());
        if seen.contains(&rev) {
            if count < 5 {
                println!("{}\t{}", word, rev);
            }
            count += 1;
        } else {
            seen.insert(word);
        }
    }
    println!("\nSemordnilap pairs found: {}", count);
    Ok(())
}

fn main() {
    match semordnilap("unixdict.txt") {
        Ok(()) => {}
        Err(error) => eprintln!("{}", error),
    }
}
