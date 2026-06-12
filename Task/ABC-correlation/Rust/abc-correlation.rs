use std::env;

fn count_character_occurences(phrase: &str, character: char, ignore_case: bool) -> usize {
    let mut count = 0;

    if ignore_case {
        for c in phrase.chars() {
            if c.to_ascii_lowercase() == character.to_ascii_lowercase() {
                count += 1;
            }
        }
    }
    else {
        for c in phrase.chars() {
            if c == character {
                count += 1;
            }
        }
    }
    count
}

fn abc_correlation(phrase: &str, ignore_case: bool) -> bool {
    let a_count = count_character_occurences(phrase, 'a', ignore_case);
    let b_count = count_character_occurences(phrase, 'b', ignore_case);
    let c_count = count_character_occurences(phrase, 'c', ignore_case);

    println!("Phrase given: {}", phrase);
    println!("Number of occurences of the letter a: {}", a_count);
    println!("Number of occurences of the letter b: {}", b_count);
    println!("Number of occurences of the letter c: {}", c_count);

    let mut output = false;
    if a_count == b_count {
        if b_count == c_count {
            output = true;
        }
    }

    println!("Conclusion is: {}", output);
    output
}

fn main() {
    let mut args: Vec<String> = env::args().collect();
    args.remove(0);
    abc_correlation(&args.join(" "), true);
}
