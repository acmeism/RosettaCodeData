use std::io;
use rand::{Rng,thread_rng};

extern crate rand;

const NUMBER_OF_DIGITS: usize = 4;

static DIGITS: [char; 9] = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

fn generate_digits() -> Vec<char> {
    let mut temp_digits: Vec<_> = (&DIGITS[..]).into();
    thread_rng().shuffle(&mut temp_digits);
    return temp_digits.iter().take(NUMBER_OF_DIGITS).map(|&a| a).collect();
}

fn parse_guess_string(guess: &str) -> Result<Vec<char>, String> {
    let chars: Vec<char> = (&guess).chars().collect();

    if !chars.iter().all(|c| DIGITS.contains(c)) {
        return Err("only digits, please".to_string());
    }

    if chars.len() != NUMBER_OF_DIGITS {
        return Err(format!("you need to guess with {} digits", NUMBER_OF_DIGITS));
    }

    let mut uniques: Vec<char> = chars.clone();
    uniques.dedup();
    if uniques.len() != chars.len() {
        return Err("no duplicates, please".to_string());
    }

    return Ok(chars);
}

fn calculate_score(given_digits: &[char], guessed_digits: &[char]) -> (usize, usize) {
    let mut bulls = 0;
    let mut cows = 0;
    for i in 0..NUMBER_OF_DIGITS {
        let pos: Option<usize> = guessed_digits.iter().position(|&a| -> bool {a == given_digits[i]});
        match pos {
            None              => (),
            Some(p) if p == i => bulls += 1,
            Some(_)           => cows += 1
        }
    }
    return (bulls, cows);
}

fn main() {
    let reader = io::stdin();

    loop {
        let given_digits = generate_digits();
        println!("I have chosen my {} digits. Please guess what they are", NUMBER_OF_DIGITS);

        loop {
            let guess_string: String = {
                let mut buf = String::new();
                reader.read_line(&mut buf).unwrap();
                buf.trim().into()
            };

            let digits_maybe = parse_guess_string(&guess_string);
            match digits_maybe {
                Err(msg) => {
                    println!("{}", msg);
                    continue;
                },
                Ok(guess_digits) => {
                    match calculate_score(&given_digits, &guess_digits) {
                        (NUMBER_OF_DIGITS, _) => {
                            println!("you win!");
                            break;
                        },
                        (bulls, cows) => println!("bulls: {}, cows: {}", bulls, cows)
                    }
                }
            }
        }
    }
}
