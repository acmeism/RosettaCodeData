use std::fs;

const WORD_LENGTH: usize = 12;

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words = wordsfile
        .split_whitespace()
        .filter(|w| w.len() >= WORD_LENGTH && w.contains("the"));
    for (i, w) in words.enumerate() {
        print!("{:<18}{}", w, if (i + 1) % 5 == 0 { "\n" } else { "" });
    }
}
