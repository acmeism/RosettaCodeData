// Return the index of the given element in the given vector
fn index_of(words: &Vec<String>, word: &String) -> i32 {
    match words.iter().position(|x| x == word) {
        Some(index) => index as i32,
        None => -1,
    }
}

// Using the Duval (1988) algorithm
fn next_word(max_length: u32, word: &String, alphabet: &Vec<String>) -> String {
    // Step 1: Repeat the word and truncate
    let mut next_word = word.clone();
    while next_word.len() < max_length as usize {
        next_word.push_str(word);
    }
    next_word.truncate(max_length as usize);

    // Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
    let alphabet_last_symbol = &alphabet[alphabet.len() - 1];
    while next_word.ends_with(alphabet_last_symbol) {
        next_word.truncate(next_word.len() - alphabet_last_symbol.len());
    }

    // Step 3: Replace the last symbol of the next word by its successor in the alphabet
    if !next_word.is_empty() {
        let word_last_symbol = next_word.chars().last().unwrap().to_string();
        let index = (index_of(alphabet, &word_last_symbol) + 1) as usize;
        next_word.pop();
        next_word.push_str(&alphabet[index]);
    }

    next_word
}

fn main() {
    let alphabet: Vec<String> = vec!["0".to_string(), "1".to_string()];
    let mut word = alphabet[0].clone();

    while !word.is_empty() {
        println!("{}", word);
        word = next_word(5, &word, &alphabet);
    }
}
