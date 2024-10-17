use std::io::{self, BufRead};

fn op(x: f32) -> Option<f32> {
    let y = x.abs().sqrt() + 5.0 * x * x * x;
    if y < 400.0 {
        Some(y)
    } else {
        None
    }
}

fn main() {
    println!("Please enter 11 numbers (one number per line)");
    let stdin = io::stdin();

    let xs = stdin
        .lock()
        .lines()
        .map(|ox| ox.unwrap().trim().to_string())
        .flat_map(|s| str::parse::<f32>(&s))
        .take(11)
        .collect::<Vec<_>>();

    for x in xs.into_iter().rev() {
        match op(x) {
            Some(y) => println!("{}", y),
            None => println!("overflow"),
        };
    }
}
