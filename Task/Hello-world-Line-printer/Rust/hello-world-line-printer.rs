use std::fs::OpenOptions;
use std::io::Write;

fn main() {
    let file = OpenOptions::new().write(true).open("/dev/lp0").unwrap();
    file.write(b"Hello, World!").unwrap();
}
