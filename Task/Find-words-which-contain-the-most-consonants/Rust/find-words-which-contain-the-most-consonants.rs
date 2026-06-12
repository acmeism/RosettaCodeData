use itertools::Itertools;
use std::fs;

const VOWELS: [char; 5] = ['a', 'e', 'i', 'o', 'u'];

fn is_c(ch: &char) -> bool {
    return !VOWELS.contains(ch);
}

fn all_c_uniq(w: &str, n: usize, cmin: usize) -> bool {
    return w.len() >= n && {
        let nunique = w.chars().sorted().dedup().filter(|c| is_c(c)).count();
        return nunique >= cmin && nunique == w.chars().filter(|c| is_c(c)).count();
    };
}

fn mostc(w: &str) -> Option<(i32, String)> {
    return if all_c_uniq(w, 11, 4) {
        Some((-(w.chars().filter(|c| is_c(c)).count() as i32), w.to_string()))
    } else {
        None
    };
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let results = wordsfile.split_whitespace().filter_map(|w| mostc(w)).collect_vec();
    println!(
        "{} words found.\n\nWord        Consonants\n----------------------",
        results.len()
    );
    for (len, word) in results.iter().sorted() {
        println!("{:<16} {}", word, -len);
    }
}
