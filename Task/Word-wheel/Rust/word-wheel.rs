fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let wheel = "ndeokgelw".to_string();
    let middle = &wheel[4..=4];

    for dictword in wordsfile.split_whitespace() {
        let mut word = dictword.to_string();
        if word.len() > 2 && word.len() <= wheel.len() && word.contains(middle) {
            for c in wheel.chars() {
                if word.contains(c) {
                    let j = word.find(c).unwrap();
                    word.replace_range(j..=j, " ");
                }
            }
            if word.chars().filter(|c| c == &' ').count() == word.len() {
                println!("{}", dictword);
            }
        }
    }
}
