use std::fs;

fn vowels_all_e(word: &&str, min_ecount: usize) -> bool {
    let letters = word.chars();
    let aiou = "aiou".chars();
    return letters.clone().filter(|c| c == &'e').count() >= min_ecount
        && aiou
            .filter(|v| letters.clone().filter(|c| c == v).count() == 0)
            .count()
            == 4;
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words = wordsfile.split_whitespace().filter(|w| vowels_all_e(w, 4));
    for (i, w) in words.enumerate() {
        print!("{:<14}{}", w, if (i + 1) % 4 == 0 { "\n" } else { "" });
    }
    return ();
}
