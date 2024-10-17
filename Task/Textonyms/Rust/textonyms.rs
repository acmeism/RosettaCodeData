use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead};

fn text_char(ch: char) -> Option<char> {
    match ch {
        'a' | 'b' | 'c' => Some('2'),
        'd' | 'e' | 'f' => Some('3'),
        'g' | 'h' | 'i' => Some('4'),
        'j' | 'k' | 'l' => Some('5'),
        'm' | 'n' | 'o' => Some('6'),
        'p' | 'q' | 'r' | 's' => Some('7'),
        't' | 'u' | 'v' => Some('8'),
        'w' | 'x' | 'y' | 'z' => Some('9'),
        _ => None,
    }
}

fn text_string(s: &str) -> Option<String> {
    let mut text = String::with_capacity(s.len());
    for c in s.chars() {
        if let Some(t) = text_char(c) {
            text.push(t);
        } else {
            return None;
        }
    }
    Some(text)
}

fn print_top_words(textonyms: &Vec<(&String, &Vec<String>)>, top: usize) {
    for (text, words) in textonyms.iter().take(top) {
        println!("{} = {}", text, words.join(", "));
    }
}

fn find_textonyms(filename: &str) -> std::io::Result<()> {
    let file = File::open(filename)?;
    let mut table = HashMap::new();
    let mut count = 0;

    for line in io::BufReader::new(file).lines() {
        let mut word = line?;
        word.make_ascii_lowercase();
        if let Some(text) = text_string(&word) {
            let words = table.entry(text).or_insert(Vec::new());
            words.push(word);
            count += 1;
        }
    }

    let mut textonyms: Vec<(&String, &Vec<String>)> =
        table.iter().filter(|x| x.1.len() > 1).collect();

    println!(
        "There are {} words in '{}' which can be represented by the digit key mapping.",
        count, filename
    );
    println!(
        "They require {} digit combinations to represent them.",
        table.len()
    );
    println!(
        "{} digit combinations represent Textonyms.",
        textonyms.len()
    );

    let top = std::cmp::min(5, textonyms.len());
    textonyms.sort_by_key(|x| (std::cmp::Reverse(x.1.len()), x.0));
    println!("\nTop {} by number of words:", top);
    print_top_words(&textonyms, top);

    textonyms.sort_by_key(|x| (std::cmp::Reverse(x.0.len()), x.0));
    println!("\nTop {} by length:", top);
    print_top_words(&textonyms, top);

    Ok(())
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 2 {
        eprintln!("usage: {} word-list", args[0]);
        std::process::exit(1);
    }
    match find_textonyms(&args[1]) {
        Ok(()) => {}
        Err(error) => eprintln!("{}: {}", args[1], error),
    }
}
