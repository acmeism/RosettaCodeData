use std::io;

fn main() {
    let mut line = String::new();
    io::stdin().read_line(&mut line).expect("reading stdin");

    let mut i: i64 = 0;
    for word in line.split_whitespace() {
        i += word.parse::<i64>().expect("trying to interpret your input as numbers");
    }
    println!("{}", i);
}
