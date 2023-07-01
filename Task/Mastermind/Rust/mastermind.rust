extern crate rand;

use rand::prelude::*;
use std::io;

fn main() {
    let mut input_line = String::new();
    let colors_n;
    let code_len;
    let guesses_max;
    let colors_dup;

    loop {
        println!("Please enter the number of colors to be used in the game (2 - 20): ");
        input_line.clear();
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        match (input_line.trim()).parse::<i32>() {
            Ok(n) => {
                if n >= 2 && n <= 20 {
                    colors_n = n;
                    break;
                } else {
                    println!("Outside of range (2 - 20).");
                }
            }
            Err(_) => println!("Invalid input."),
        }
    }
    let colors = &"ABCDEFGHIJKLMNOPQRST"[..colors_n as usize];

    println!("Playing with colors {}.\n", colors);

    loop {
        println!("Are duplicated colors allowed in the code? (Y/N): ");
        input_line.clear();
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        if ["Y", "N"].contains(&&input_line.trim().to_uppercase()[..]) {
            colors_dup = input_line.trim().to_uppercase() == "Y";
            break;
        } else {
            println!("Invalid input.");
        }
    }
    println!(
        "Duplicated colors {}allowed.\n",
        if colors_dup { "" } else { "not " }
    );
    loop {
        let min_len = if colors_dup { 4 } else { 4.min(colors_n) };
        let max_len = if colors_dup { 10 } else { 10.min(colors_n) };
        println!(
            "Please enter the length of the code ({} - {}): ",
            min_len, max_len
        );
        input_line.clear();
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        match (input_line.trim()).parse::<i32>() {
            Ok(n) => {
                if n >= min_len && n <= max_len {
                    code_len = n;
                    break;
                } else {
                    println!("Outside of range ({} - {}).", min_len, max_len);
                }
            }
            Err(_) => println!("Invalid input."),
        }
    }
    println!("Code of length {}.\n", code_len);
    loop {
        println!("Please enter the number of guesses allowed (7 - 20): ");
        input_line.clear();
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        match (input_line.trim()).parse::<i32>() {
            Ok(n) => {
                if n >= 7 && n <= 20 {
                    guesses_max = n;
                    break;
                } else {
                    println!("Outside of range (7 - 20).");
                }
            }
            Err(_) => println!("Invalid input."),
        }
    }
    println!("{} guesses allowed.\n", guesses_max);

    let mut rng = rand::thread_rng();
    let mut code;
    if colors_dup {
        code = (0..code_len)
            .map(|_| ((65 + rng.gen_range(0, colors_n) as u8) as char))
            .collect::<Vec<_>>();
    } else {
        code = colors.chars().collect::<Vec<_>>();
        code.shuffle(&mut rng);
        code = code[..code_len as usize].to_vec();
    }
    //code = vec!['J', 'A', 'R', 'D', 'A', 'N', 'I'];
    //println!("Secret code: {:?}", code);
    let mut guesses: Vec<(String, String)> = vec![];
    let mut i = 1;
    loop {
        println!("Your guess ({}/{})?: ", i, guesses_max);
        input_line.clear();
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        let mut guess = input_line.trim().to_uppercase();
        if guess.len() as i32 > code_len {
            guess = guess[..code_len as usize].to_string();
        }
        let guess_v = guess.chars().collect::<Vec<char>>();
        let res = evaluate(&code, &guess_v);
        guesses.push((guess, res.clone()));
        let width = 8 + guesses_max.to_string().len() + code_len as usize * 2;
        println!("{}", "-".repeat(width));
        for (i, guess) in guesses.iter().enumerate() {
            let line = format!(
                " {:w1$} : {:w2$} : {:w2$} ",
                i + 1,
                guess.0,
                guess.1,
                w1 = guesses_max.to_string().len(),
                w2 = code_len as usize
            );
            println!("{}", line);
        }
        println!("{}", "-".repeat(width));
        if res == "X".repeat(code_len as usize) {
            println!("You won! Code: {}", code.into_iter().collect::<String>());
            break;
        }
        i += 1;
        if i > guesses_max {
            println!("You lost. Code: {}", code.into_iter().collect::<String>());
            break;
        }
    }
}

fn evaluate(code: &[char], guess: &[char]) -> String {
    let mut res: Vec<char> = vec![];
    for i in 0..guess.len() {
        if guess[i] == code[i] {
            res.push('X');
        } else if code.contains(&guess[i]) {
            res.push('O');
        } else {
            res.push('-');
        }
    }
    res.sort_by(|a, b| b.cmp(a));
    res.into_iter().collect()
}
