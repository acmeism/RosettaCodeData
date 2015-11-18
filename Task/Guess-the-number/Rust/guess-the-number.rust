extern crate rand;

fn main() {
    println!("Type in an integer between 1 and 10 and press enter.");

    let n = rand::random::<u32>() % 10 + 1;
    loop {
        let mut line = String::new();
        std::io::stdin().read_line(&mut line).unwrap();
        let option: Result<u32,_> = line.trim().parse();
        match option {
            Ok(guess) => {
                if guess < 1 || guess > 10 {
                    println!("Guess is out of bounds; try again.");
                } else if guess == n {
                    println!("Well guessed!");
                    break;
                } else {
                    println!("Wrong! Try again.");
                }
            },
            Err(_) => println!("Invalid input; try again.")
        }
    }
}
