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
    match load_dictionary("unixdict.txt", 6) {
        Ok(dictionary) => {
            let mut count = 0;
            for word in dictionary.iter().filter(|x| x.contains("e")) {
                let word2 = word.replace("e", "i");
                if dictionary.contains(&word2) {
                    count += 1;
                    println!("{:2}. {:<9} -> {}", count, word, word2);
                }
            }
        }
        Err(error) => eprintln!("{}", error),
    }
}
