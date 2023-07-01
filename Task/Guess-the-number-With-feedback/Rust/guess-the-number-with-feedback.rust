use rand::Rng;
use std::cmp::Ordering;
use std::io;

const LOWEST: u32 = 1;
const HIGHEST: u32 = 100;

fn main() {
    let secret_number = rand::thread_rng().gen_range(1..101);

    println!("I have chosen my number between {} and {}. Guess the number!", LOWEST, HIGHEST);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }
}
