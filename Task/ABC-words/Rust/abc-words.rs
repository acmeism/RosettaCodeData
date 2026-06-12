use std::fs;

fn isabcword(word: &&str) -> bool {
    let positions = ['a', 'b', 'c']
        .iter()
        .filter_map(|c| word.find(*c))
        .collect::<Vec<usize>>();
    return positions.len() == 3 && positions.windows(2).all(|w| w[0] <= w[1]);
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words = wordsfile.split_whitespace().filter(|w| isabcword(w));
    for (i, w) in words.enumerate() {
        print!("{:<14}{}", w, if (i + 1) % 6 == 0 { "\n" } else { "" });
    }
    return ();
}
