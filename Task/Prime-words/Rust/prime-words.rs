// [dependencies]
// primal = "0.3"

use std::fs::File;
use std::io::{self, BufRead};

fn print_prime_words(filename: &str) -> std::io::Result<()> {
    let sieve = primal::Sieve::new(std::char::MAX as usize);
    let file = File::open(filename)?;
    let mut n = 0;
    for line in io::BufReader::new(file).lines() {
        let word = line?;
        if word.chars().all(|c| sieve.is_prime(c as usize)) {
            n += 1;
            print!("{:2}: {:<10}", n, word);
            if n % 4 == 0 {
                println!();
            }
        }
    }
    Ok(())
}

fn main() {
    match print_prime_words("unixdict.txt") {
        Ok(()) => {}
        Err(error) => eprintln!("{}", error),
    }
}
