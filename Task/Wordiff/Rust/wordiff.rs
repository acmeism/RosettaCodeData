use rand::seq::SliceRandom;
use std::collections::HashSet;
use std::fs;
use std::io::Write;

fn request_player_names(wanted: i32) -> Vec<String> {
    let mut player_names = vec![];
    for i in 0..wanted {
        let mut buf = String::new();
        print!("\nPlease enter the player's name for player {}: ", i + 1);
        let _ = std::io::stdout().flush();
        let _ = std::io::stdin().read_line(&mut buf);
        player_names.push(buf.trim_end().to_owned());
    }
    return player_names;
}

fn is_letter_removed(previous_word: &str, current_word: &str) -> bool {
    for i in 0..previous_word.len() {
        if current_word == previous_word[..i].to_owned() + &previous_word[i + 1..] {
            return true;
        }
    }
    return false;
}

fn is_letter_added(previous_word: &str, current_word: &str) -> bool {
    return is_letter_removed(current_word, previous_word);
}

fn is_letter_changed(previous_word: &str, current_word: &str) -> bool {
    if previous_word.len() != current_word.len() {
        return false;
    }

    let mut difference_count = 0;
    for i in 0..current_word.len() {
        difference_count += (current_word[i..=i] != previous_word[i..=i]) as usize;
    }
    return difference_count == 1;
}

fn is_wordiff(current_word: &str, words_used: &Vec<String>, dictionary: &HashSet<&str>) -> bool {
    if !dictionary.contains(current_word) || words_used.contains(&current_word.to_string()) {
        return false;
    }
    let previous_word = words_used.last().unwrap();
    return is_letter_changed(previous_word, current_word)
        || is_letter_removed(previous_word, current_word)
        || is_letter_added(previous_word, current_word);
}

fn could_have_entered(words_used: &Vec<String>, dictionary: &HashSet<&str>) -> Vec<String> {
    let mut result: Vec<String> = vec![];
    for word in dictionary {
        if is_wordiff(word, words_used, dictionary) {
            result.push(word.to_string());
        }
    }
    return result;
}

fn main() {
    let mut rng = rand::thread_rng();
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let words = wordsfile.split_whitespace().collect::<Vec<&str>>();
    let dictionary: &HashSet<&str> = &words.iter().cloned().collect();
    let mut starters = words
        .clone()
        .into_iter()
        .filter(|w| w.len() == 3 || w.len() == 4)
        .collect::<Vec<&str>>();
    starters.shuffle(&mut rng);
    let mut words_used = vec![starters[0].to_string(); 1];

    let player_names = request_player_names(2);
    let mut playing = true;
    let mut player_index = 0_usize;
    let mut current_word = words_used.last().unwrap().to_string();
    println!("\nThe first word is: {}", current_word);
    let _ = std::io::stdout().flush();

    while playing {
        print!("{}, enter your word: ", player_names[player_index]);
        let _ = std::io::stdout().flush();
        current_word.clear();
        let _ = std::io::stdin().read_line(&mut current_word);
        current_word = current_word.trim_end().to_owned();
        println!("You entered {}.", current_word);
        if is_wordiff(&current_word, &words_used, dictionary) {
            words_used.push(current_word.clone());
            player_index = (player_index + 1) % player_names.len();
        } else {
            println!("You have lost the game, {}.", player_names[player_index]);
            let missed_words = could_have_entered(&words_used, dictionary);
            println!("You could have entered: {:?}", missed_words);
            playing = false;
        }
    }
}
