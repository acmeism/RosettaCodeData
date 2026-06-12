use std::cmp::Ordering;
use std::collections::HashSet;
use std::fs;

fn ischangeable(word: &str, hset: &HashSet<&str>) -> Option<String> {
    for (i, oldchar) in word.chars().enumerate() {
        for c in 'a'..='z' {
            if c != oldchar {
                let mut candidate: String = word.to_string();
                let ch = c.to_string();
                candidate.replace_range(i..i + 1, &ch);
                if hset.contains(candidate.as_str()) {
                    if candidate.cmp(&word.to_string()) == Ordering::Less {
                        return Some(String::new() + &candidate + " <==> " + word);
                    } else {
                        return Some(String::new() + word + " <==> " + &candidate);
                    }
                }
            }
        }
    }
    return None;
}

fn main() {
    let wordfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words: Vec<&str> = wordfile.split_whitespace().collect();
    let words_hash_set: HashSet<&str> = words.iter().filter(|w| w.len() > 11).cloned().collect();
    let mut changeables: Vec<String> = words
        .iter()
        .filter_map(|w| ischangeable(w, &words_hash_set))
        .collect();
    changeables.dedup();

    for i in 0..changeables.len() {
        print!(
            "{:<36}{}",
            changeables[i],
            if i & 1 == 1 { "\n" } else { "" }
        );
    }
    return ();
}
