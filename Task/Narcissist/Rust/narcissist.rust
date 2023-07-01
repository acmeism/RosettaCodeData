use std::io::{stdin, prelude::*};
fn main() {
    let src = include_str!("main.rs");
    let mut input = String::new();
    stdin()
        .lock()
        .read_to_string(&mut input)
        .expect("Could not read from STDIN");
    println!("{}", src == input);
}
