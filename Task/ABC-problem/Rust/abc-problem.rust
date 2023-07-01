use std::iter::repeat;

fn rec_can_make_word(index: usize, word: &str, blocks: &[&str], used: &mut[bool]) -> bool {
    let c = word.chars().nth(index).unwrap().to_uppercase().next().unwrap();
    for i in 0..blocks.len() {
        if !used[i] && blocks[i].chars().any(|s| s == c) {
            used[i] = true;
            if index == 0 || rec_can_make_word(index - 1, word, blocks, used) {
                return true;
            }
            used[i] = false;
        }
    }
    false
}

fn can_make_word(word: &str, blocks: &[&str]) -> bool {
    return rec_can_make_word(word.chars().count() - 1, word, blocks,
                             &mut repeat(false).take(blocks.len()).collect::<Vec<_>>());
}

fn main() {
    let blocks = [("BO"), ("XK"), ("DQ"), ("CP"), ("NA"), ("GT"), ("RE"), ("TG"), ("QD"), ("FS"),
                  ("JW"), ("HU"), ("VI"), ("AN"), ("OB"), ("ER"), ("FS"), ("LY"), ("PC"), ("ZM")];
    let words = ["A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"];
    for word in &words {
        println!("{} -> {}", word, can_make_word(word, &blocks))
    }
}
