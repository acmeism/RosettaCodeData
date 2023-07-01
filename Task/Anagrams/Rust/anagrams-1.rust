use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead,BufReader};
use std::borrow::ToOwned;

extern crate unicode_segmentation;
use unicode_segmentation::{UnicodeSegmentation};

fn main () {
    let file = BufReader::new(File::open("unixdict.txt").unwrap());
    let mut map = HashMap::new();
    for line in file.lines() {
        let s = line.unwrap();
        //Bytes:      let mut sorted = s.trim().bytes().collect::<Vec<_>>();
        //Codepoints: let mut sorted = s.trim().chars().collect::<Vec<_>>();
        let mut sorted = s.trim().graphemes(true).map(ToOwned::to_owned).collect::<Vec<_>>();
        sorted.sort();

        map.entry(sorted).or_insert_with(Vec::new).push(s);
    }

    if let Some(max_len) = map.values().map(|v| v.len()).max() {
        for anagram in map.values().filter(|v| v.len() == max_len) {
            for word in anagram {
                print!("{} ", word);
            }
            println!();
        }
    }
}
