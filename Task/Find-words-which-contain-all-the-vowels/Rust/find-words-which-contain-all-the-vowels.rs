use std::fs;

fn hasoneofeachvowel(word: &&str, minsize: usize) -> bool {
    if word.len() < minsize {
        return false;
    }
    let letters = word.chars();
    let vowels = "aeiou".chars();
    return vowels
        .filter(|v| letters.clone().filter(|c| c == v).count() == 1)
        .count()
        == 5;
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words = wordsfile
        .split_whitespace()
        .filter(|w| hasoneofeachvowel(w, 11));
    for (i, w) in words.enumerate() {
        print!("{:<15}{}", w, if (i + 1) % 5 == 0 { "\n" } else { "" });
    }
    return ();
}
