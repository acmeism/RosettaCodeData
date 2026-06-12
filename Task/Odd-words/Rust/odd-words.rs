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

fn print_words(words: &[(&String, String)]) {
    for (i, (a, b)) in words.iter().enumerate() {
        println!("{:2}: {:<14}{}", i + 1, a, b);
    }
}

fn main() {
    let min_length = 5;
    match load_dictionary("unixdict.txt", min_length) {
        Ok(dictionary) => {
            let mut odd_words = Vec::new();
            let mut even_words = Vec::new();
            for word in &dictionary {
                if word.len() < min_length + 2 * (min_length / 2) {
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
                if dictionary.contains(&odd_word) {
                    odd_words.push((word, odd_word));
                }
                if dictionary.contains(&even_word) {
                    even_words.push((word, even_word));
                }
            }
            println!("Odd words:");
            print_words(&odd_words);
            println!("\nEven words:");
            print_words(&even_words);
        }
        Err(error) => eprintln!("{}", error),
    }
}
