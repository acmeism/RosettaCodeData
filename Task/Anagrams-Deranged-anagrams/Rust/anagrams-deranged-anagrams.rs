//! Deranged anagrams
use std::cmp::Ordering;
use std::collections::HashMap;
use std::fs::File;
use std::io;
use std::io::BufReader;
use std::io::BufRead;
use std::usize::MAX;

/// Get words from unix dictionary file
pub fn get_words() -> Result<Vec<String>, io::Error> {
    let mut words = vec!();
    // open file
    let f = File::open("data/unixdict.txt")?;
    // read line by line
    let reader = BufReader::new(&f);
    for line in reader.lines() {
        words.push(line?)
    }
    Ok(words)
}

/// Get the longest deranged anagram in the given list of word if any
pub fn longest_deranged(v: &mut Vec<String>) -> Option<(String,String)>{
    // sort by length descending then by alphabetical order
    v.sort_by(|s1, s2| {
        let mut c = s2.len().cmp(&s1.len());
        if c == Ordering::Equal {
            c = s1.cmp(s2);
        }
        c
    });
    // keep all strings keyed by sorted characters (since anagrams have the same list of sorted characters)
    let mut signatures : HashMap<Vec<char>, Vec<&String>> = HashMap::new();
    // save on memory by only keeping in the map strings of the current processed length
    let mut previous_length = MAX;
    for s in v {
        // length change, clear the map
        if s.len()<previous_length {
            signatures.clear();
            previous_length = s.len();
        }
        // generate key as sorted characters
        let mut sorted_chars = s.chars().collect::<Vec<char>>();
        sorted_chars.sort();
        let anagrams = signatures.entry(sorted_chars).or_insert(vec!());
        // find if any anagram (string with the same sorted character vector) is deranged
        if let Some(a) = anagrams.iter().filter(|anagram| is_deranged(anagram, s)).next(){
            return Some(((*a).clone(), s.clone()));
        }
        anagrams.push(s);
    }
    None
}

/// check if two strings do NOT have the same character in the same position
pub fn is_deranged(s1: &String, s2: &String) -> bool {
    // we zip the character iterators and check we find no position with the same two characters
    s1.chars().zip(s2.chars()).filter(|(a,b)| a == b).next().is_none()
}

/// an example main method printing the results
fn main() {
    let r = get_words();
    match r {
        Ok(mut v) => {
            let od = longest_deranged(&mut v);
            match od {
                None => println!("No deranged anagrams found!"),
                Some((s1,s2)) => println!("{} {}",s1,s2),
            }
        },
        Err(e) => panic!("Could not read words: {}",e)
    }
}
