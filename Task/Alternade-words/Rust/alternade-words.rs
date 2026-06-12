use std::collections::BTreeSet;
use std::fs::File;
use std::io::{self, BufRead};

fn load_dictionary(filename: &str) -> std::io::Result<BTreeSet<String>> {
    let file = File::open(filename)?;
    let mut dict = BTreeSet::new();
    for line in io::BufReader::new(file).lines() {
        dict.insert(line?);
    }
    Ok(dict)
}

fn main() {
    match load_dictionary("unixdict.txt") {
        Ok(dictionary) => {
            for word in &dictionary {
                if word.len() < 6 {
                    continue;
                }
                let mut odd_word = String::new();
                let mut even_word = String::new();
                for (i, c) in word.chars().enumerate() {
                    if (i & 1) == 0 {
                        odd_word.push(c);
                    } else {
                        even_word.push(c);
                    }
                }
                if dictionary.contains(&odd_word) && dictionary.contains(&even_word) {
                    println!("{:<10}{:<6}{}", word, odd_word, even_word);
                }
            }
        }
        Err(error) => eprintln!("{}", error),
    }
}
