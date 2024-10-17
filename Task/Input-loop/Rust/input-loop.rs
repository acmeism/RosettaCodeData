 use std::io::{self, BufReader, Read, BufRead};
use std::fs::File;

fn main() {
    print_by_line(io::stdin())
        .expect("Could not read from stdin");

    File::open("/etc/fstab")
        .and_then(print_by_line)
        .expect("Could not read from file");
}

fn print_by_line<T: Read>(reader: T) -> io::Result<()> {
    let buffer = BufReader::new(reader);
    for line in buffer.lines() {
        println!("{}", line?)
    }
    Ok(())
}
