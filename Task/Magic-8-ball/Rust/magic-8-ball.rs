extern crate rand;

use rand::prelude::*;
use std::io;

fn main() {
    let answers = [
        "It is certain",
        "It is decidedly so",
        "Without a doubt",
        "Yes, definitely",
        "You may rely on it",
        "As I see it, yes",
        "Most likely",
        "Outlook good",
        "Signs point to yes",
        "Yes",
        "Reply hazy, try again",
        "Ask again later",
        "Better not tell you now",
        "Cannot predict now",
        "Concentrate and ask again",
        "Don't bet on it",
        "My reply is no",
        "My sources say no",
        "Outlook not so good",
        "Very doubtful",
    ];
    let mut rng = rand::thread_rng();
    let mut input_line = String::new();

    println!("Please enter your question or a blank line to quit.\n");
    loop {
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        if input_line.trim() == "" {
            break;
        }
        println!("{}\n", answers.choose(&mut rng).unwrap());
        input_line.clear();
    }
}
