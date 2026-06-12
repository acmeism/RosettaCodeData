use std::collections::BTreeSet;
use std::fs::File;
use std::io::{self, BufRead};

fn load_dictionary(filename: &str, min_length: usize) -> std::io::Result<BTreeSet<String>> {
    let file = File::open(filename)?;
    let mut dict = BTreeSet::new();
    for line in io::BufReader::new(file).lines() {
        let word = line?;
        if word.len() >= min_length {
            dict.insert(word);
        }
    }
    Ok(dict)
}

fn main() {
    match load_dictionary("words.txt", 7) {
        Ok(dictionary) => {
            for word in &dictionary {
                let rev = String::from_iter(word.chars().rev());
                if rev > *word && dictionary.contains(&rev) {
                    println!("{:<8} <-> {}", word, rev);
                }
            }
        }
        Err(error) => eprintln!("{}", error),
    }
}
