use std::collections::BTreeSet;
use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};
use std::iter::FromIterator;

fn load_dictionary(filename: &str) -> std::io::Result<BTreeSet<String>> {
    let file = File::open(filename)?;
    let mut dict = BTreeSet::new();
    for line in io::BufReader::new(file).lines() {
        let word = line?;
        dict.insert(word);
    }
    Ok(dict)
}

fn find_teacup_words(dict: &BTreeSet<String>) {
    let mut teacup_words: Vec<&String> = Vec::new();
    let mut found: HashSet<&String> = HashSet::new();
    for word in dict {
        let len = word.len();
        if len < 3 || found.contains(word) {
            continue;
        }
        teacup_words.clear();
        let mut is_teacup_word = true;
        let mut chars: Vec<char> = word.chars().collect();
        for _ in 1..len {
            chars.rotate_left(1);
            if let Some(w) = dict.get(&String::from_iter(&chars)) {
                if !w.eq(word) && !teacup_words.contains(&w) {
                    teacup_words.push(w);
                }
            } else {
                is_teacup_word = false;
                break;
            }
        }
        if !is_teacup_word || teacup_words.is_empty() {
            continue;
        }
        print!("{}", word);
        found.insert(word);
        for w in &teacup_words {
            found.insert(w);
            print!(" {}", w);
        }
        println!();
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: teacup dictionary");
        std::process::exit(1);
    }
    let dict = load_dictionary(&args[1]);
    match dict {
        Ok(dict) => find_teacup_words(&dict),
        Err(error) => eprintln!("Cannot open file {}: {}", &args[1], error),
    }
}
