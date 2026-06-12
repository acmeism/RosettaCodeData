use std::fs;

fn firstsamelast(word: &&str, min_same: usize) -> bool {
    let n = word.len();
    return n >= 2 * min_same && word[..min_same] == word[n - min_same..];
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words = wordsfile.split_whitespace().filter(|w| firstsamelast(w, 3));
    for (i, w) in words.enumerate() {
        print!("{:<16}{}", w, if (i + 1) % 4 == 0 { "\n" } else { "" });
    }
    return ();
}
