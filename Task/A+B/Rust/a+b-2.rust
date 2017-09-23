use std::io;

fn main() {
    let mut line = String::new();
    io::stdin().read_line(&mut line).expect("reading stdin");

    let sum: i64 = line.split_whitespace()
                       .map(|x| x.parse::<i64>().expect("Not an integer"))
                       .sum();
    println!("{}", sum);
}
