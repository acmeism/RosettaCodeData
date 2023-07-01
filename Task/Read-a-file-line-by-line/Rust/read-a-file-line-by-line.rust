use std::io::{BufReader,BufRead};
use std::fs::File;

fn main() {
    let file = File::open("file.txt").unwrap();
    for line in BufReader::new(file).lines() {
        println!("{}", line.unwrap());
    }
}
