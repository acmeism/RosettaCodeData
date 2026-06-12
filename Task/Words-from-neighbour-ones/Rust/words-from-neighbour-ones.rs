use std::fs;

const WORD_LENGTH: usize = 9;

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words: Vec<&str> = wordsfile
        .split_whitespace()
        .filter(|w| w.len() >= WORD_LENGTH)
        .collect();
    let fromneigh = (0..words.len()-WORD_LENGTH)
        .map(|i| {
            words[i..i + WORD_LENGTH]
                .iter()
                .enumerate()
                .map(|(i, w)| w.to_string()[i..=i].to_string())
                .collect::<Vec<String>>()
                .join("")
        })
        .filter(|w| words.contains(&w.as_str()));
    for (i, w) in fromneigh.enumerate() {
        print!("{:<11}{}", w, if (i + 1) % 7 == 0 { "\n" } else { "" });
    }
}

