use std::{env, fs, process};
use std::io::{self, Write};
use std::fmt::Display;

fn main() {
    let file_name = env::args().nth(1).unwrap_or_else(|| exit_err("No file name supplied", 1));
    let metadata = fs::metadata(file_name).unwrap_or_else(|e| exit_err(e, 2));

    println!("Size of file.txt is {} bytes", metadata.len());
}

#[inline]
fn exit_err<T: Display>(msg: T, code: i32) -> ! {
    writeln!(&mut io::stderr(), "Error: {}", msg).expect("Could not write to stdout");
    process::exit(code)
}

}
