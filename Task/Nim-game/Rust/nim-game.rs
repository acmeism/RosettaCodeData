fn main() {
    let mut tokens = 12;
    println!("Nim game");
    println!("Starting with {} tokens.", tokens);
    println!("");

    loop {
        tokens = p_turn(&tokens);
        print_remaining(&tokens);
        tokens = c_turn(&tokens);
        print_remaining(&tokens);

        if tokens == 0 {
            println!("Computer wins!");
            break;
        }
    }
}

fn p_turn(tokens: &i32) -> i32 {
    loop {  //try until we get a good number
        println!("How many tokens would you like to take?");

        let mut take = String::new();
        io::stdin().read_line(&mut take)
            .expect("Sorry, I didn't understand that.");

        let take: i32 = match take.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Invalid input");
                println!("");
                continue;
            }
        };

        if take > 3 || take < 1 {
            println!("Take must be between 1 and 3.");
            println!("");
            continue;
        }

        return tokens - take;
    }
}

fn c_turn(tokens: &i32) -> i32 {
    let take = tokens % 4;

    println!("Computer takes {} tokens.", take);

    return tokens - take;
}

fn print_remaining(tokens: &i32) {
    println!("{} tokens remaining.", tokens);
    println!("");
}
