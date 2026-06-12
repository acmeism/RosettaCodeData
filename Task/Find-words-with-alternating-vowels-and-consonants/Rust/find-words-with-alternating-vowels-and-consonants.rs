use regex::Regex;
use std::fs;

fn main() {
    let re = Regex::new( // >= 10 chars is >= 5 pairs of chars
        r"(?ix) ^ (?: (?:[^AEIOU][AEIOU]){5,}[^AEIOU]? |
                         (?:[AEIOU][^AEIOU]){5,}[AEIOU]? ) $")
        .unwrap();
    let wordfile = fs::read_to_string("unixdict.txt").unwrap();
    let words: Vec<&str> = Regex::new(r"\s+")
        .unwrap()
        .split(&wordfile)
        .filter(|w| re.is_match(w))
        .collect();

    for i in 0..words.len() {
        print!("{:<14}{}", words[i], if (i + 1) % 6 == 0 {"\n"} else {""});
    }
    return ();
}
